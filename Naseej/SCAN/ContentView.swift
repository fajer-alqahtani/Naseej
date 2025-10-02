import SwiftUI
import UIKit
import CoreImage

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

// MARK: - دالة مؤقتة للتحليل
func processDocumentWith(ciImage: CIImage) -> String {
    // مؤقتاً نرجع نص للتجربة فقط
    let w = Int(ciImage.extent.width), h = Int(ciImage.extent.height)
    return "✅ Image received (\(w)x\(h))."
}

//MARK: COLORS
//extension Color {
  //  init(hex: String) {
    //    let scanner = Scanner(string: hex)
      //  _ = scanner.scanString("#")
        //var rgb: UInt64 = 0
        //scanner.scanHexInt64(&rgb)
        //let r = Double((rgb >> 16) & 0xFF) / 255.0
        //let g = Double((rgb >>  8) & 0xFF) / 255.0
        //let b = Double(rgb & 0xFF) / 255.0
        //self.init(red: r, green: g, blue: b)
  //  }
//}

// MARK: - ContentView
struct SCANContentView: View {
    @State private var output: String = "Result will appear here"
    @State private var showImagePicker = false
    @State private var pickerSource: ImagePicker.SourceType = .camera

    var body: some View {
        VStack {
            Spacer()

            // مربع الكاميرا
            Button(action: {
                pickerSource = .camera
                showImagePicker = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                        .frame(width: 340, height: 350)

                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.black)
                }
            }

            // زر upload (دائري برمز واحد فقط)
            Button(action: {
                pickerSource = .photoLibrary
                showImagePicker = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60)
                    Image(systemName: "arrow.up.doc.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.teal)
                    Text ("upload")
                        .padding(.top , 100)
                }
            }
            .padding(.top, 200)

            Spacer()

            // زر سفلي (مثلاً share)
            Button(action: {
                print("Bottom button tapped")
            }) {
              
            }
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSource) { image in
                if let uiImage = image, let ciImage = CIImage(image: uiImage) {
                    output = processDocumentWith(ciImage: ciImage)
                } else {
                    output = "No image selected"
                }
            }
        }
    }
}

#Preview {
    SCANContentView()
}
