import SwiftUI
import UIKit
import CoreImage
import Vision

// MARK: - ImagePicker (الكاميرا/الألبوم)
struct ImagePicker: UIViewControllerRepresentable {
    enum SourceType { case camera, photoLibrary }

    var sourceType: SourceType
    var completion: (UIImage?) -> Void
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = (sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(.camera))
            ? .camera : .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.completion(info[.originalImage] as? UIImage)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.completion(nil)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Simple OCR result for navigation
struct ScanResult: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage?
    let fabric: FabricInfo
    // Hash/Equality by id only (UIImage isn’t Hashable)
    static func == (lhs: ScanResult, rhs: ScanResult) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct SCANContentView: View {
    @State private var isScanning = false
    @State private var scanError: String?
    @State private var lastPhoto: UIImage? = nil                   // keep latest captured image
    @State private var navResult: ScanResult? = nil                // used for navigation
    @State private var showImagePicker = false
    @State private var pickerSource: ImagePicker.SourceType = .camera

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 236/255, green: 236/255, blue: 232/255), .white],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer(minLength: 16)

                    // Camera “card”
                    Button {
                        pickerSource = .camera
                        showImagePicker = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 236/255, green: 236/255, blue: 232/255))
                                .frame(width: 340, height: 350)
                            Image(systemName: "camera.fill")
                                .resizable().scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }
                    }

                    // Upload
                    Button {
                        pickerSource = .photoLibrary
                        showImagePicker = true
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle().fill(Color(.systemGray6))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "arrow.up.doc.fill")
                                    .resizable().scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.teal)
                            }
                            Text("upload").font(.footnote).foregroundColor(.teal)
                        }
                    }

                    if isScanning { ProgressView("Reading label…") }
                    if let err = scanError {
                        Text(err).foregroundColor(.red).font(.footnote)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
            }
            // Navigate when navResult becomes non-nil
            .navigationDestination(item: $navResult) { result in
                Main(fabricImage: result.image)           // pass the photo to Main
                    .navigationTitle(result.fabric.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSource) { image in
                guard let ui = image else { return }
                lastPhoto = ui
                runOCRAndParse(uiImage: ui)
            }
        }
    }
}

// MARK: - OCR + Parse
private extension SCANContentView {
    func runOCRAndParse(uiImage: UIImage) {
        isScanning = true
        scanError = nil

        guard let cg = uiImage.cgImage else {
            isScanning = false
            scanError = "Could not read image."
            return
        }

        let request = VNRecognizeTextRequest { req, _ in
            DispatchQueue.main.async {
                self.isScanning = false
                let text = (req.results as? [VNRecognizedTextObservation])?
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n") ?? ""

                if let fabric = self.parseFabric(from: text) {
                    self.navResult = ScanResult(image: self.lastPhoto, fabric: fabric)
                } else {
                    self.scanError = "Couldn’t understand the label. Try a clearer photo."
                }
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isScanning = false
                    self.scanError = "OCR failed: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Very simple parser, adjusts as you like
    func parseFabric(from text: String) -> FabricInfo? {
        let lower = text.lowercased()
        func percent(of keyword: String) -> Double? {
            let k = NSRegularExpression.escapedPattern(for: keyword.lowercased())
            let pattern = "(\\d{1,3})\\s*%\\s*\\b\(k)\\b"
            guard let rgx = try? NSRegularExpression(pattern: pattern) else { return nil }
            let range = NSRange(lower.startIndex..<lower.endIndex, in: lower)
            guard let m = rgx.firstMatch(in: lower, range: range),
                  let r = Range(m.range(at: 1), in: lower),
                  let val = Int(lower[r]) else { return nil }
            return Double(val)
        }

        let poly = percent(of: "polyester") ?? 0
        let cotton = percent(of: "cotton") ?? 0
        let linen = percent(of: "linen") ?? 0
        let elastane = percent(of: "elastane") ?? percent(of: "spandex") ?? 0

        if max(poly, cotton, linen, elastane) == 0 { return nil }

        var parts: [String] = []
        if poly > 0 { parts.append("\(Int(poly))% Polyester") }
        if cotton > 0 { parts.append("\(Int(cotton))% Cotton") }
        if linen > 0 { parts.append("\(Int(linen))% Linen") }
        if elastane > 0 { parts.append("\(Int(elastane))% Elastane") }

        let name: String = {
            if poly >= cotton && poly >= linen { return "Polyester Blend" }
            if cotton >= poly && cotton >= linen { return "Cotton Blend" }
            if linen >= poly && linen >= cotton { return "Linen Blend" }
            return "Fabric"
        }()

        let score: Double = {
            if linen > 50 { return 9.0 }
            if cotton > 50 { return 7.5 }
            if poly > 60 { return 3.0 }
            return 5.0
        }()

        let babies = (cotton + linen) > poly
        let notes = babies ? "Generally gentle on skin." : "May feel warm; limited airflow."

        return FabricInfo(
            name: name,
            composition: parts.joined(separator: ", "),
            score: score,
            bestTempRangeC: babies ? "22–30" : "16–24",
            suitableForBabies: babies,
            notes: notes
        )
    }
}

// Preview
#Preview {
    SCANContentView()
}
