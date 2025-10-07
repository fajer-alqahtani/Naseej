//
//  Main.swift
//  Naseej
//
//  Created by Fajer alQahtani on 13/04/1447 AH.
//
import SwiftUI

struct Main: View {
    let fabricImage: UIImage?
    // Button titles (kept for your grid)
    private let buttonTitles = ["Quality", "Care Instructions", "Breathability", "Allergies"]

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - (ADD) Sheet wiring
    private enum MainSheet: Identifiable {
        case care, breathability, quality, allergies
        var id: Int { hashValue }
    }
    @State private var activeSheet: MainSheet? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 236/255, green: 236/255, blue: 232/255)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 25) {

                    // Custom back (only shows on this root)
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }

                    // Header
                    HStack(alignment: .top, spacing: 15) {
                        if let img = fabricImage {
                            Image(uiImage: img)
                                .resizable()
                                .cornerRadius(10)
                            .frame(width: 80, height: 100)}

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Shirt")
                                .font(.headline).bold()
                                .foregroundColor(.black)

                            Text("Polyester Blend")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 30)

                    Text("Composition: 94% Polyester, 6% Elastane\nNatural: 0% | Synthetic: 100%")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)

                    Spacer()

                    // Grid of buttons that open sheets
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                        ForEach(buttonTitles, id: \.self) { title in
                            // keep the look via your ButtonStyle
                            Button(title) {
                                switch title {
                                case "Care Instructions": activeSheet = .care
                                case "Breathability":     activeSheet = .breathability
                                case "Quality":           activeSheet = .quality
                                case "Allergies":         activeSheet = .allergies
                                default:                  activeSheet = nil
                                }
                            }
                            .buttonStyle(CustomButtonStyle(cornerRadius: 15))
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
            }
        }
        // MARK: - (ADD) One place to present the sheets
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .care:
                CareContentView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)

            case .breathability:
                BreathabilitySheet()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)

            case .quality:
                Quality()
                    .presentationDetents([.large])
                .presentationDragIndicator(.visible)

            case .allergies:
                Allergy()
                    .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    } // <— ✅ close `var body` here

    // MARK: - Destination resolver (kept but unused now)
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case "Care Instructions":
            CareContentView()
        case "Breathability":
            BreathabilitySheet()
        default:
            EmptyView()
        }
    }
}

// Your existing button style (unchanged)

#Preview {
    Main(fabricImage: nil)
}
