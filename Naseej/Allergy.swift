//
//  Allergy.swift
//  Naseej
//
//  Created by Fajer alQahtani on 13/04/1447 AH.
//

import SwiftUI

// MARK: - Color Extension


// MARK: - Palette
private let BG_BASE   = Color(hex: "#D9E5E4")
private let BG_TOP    = Color(hex: "#E7F0EF")
private let BG_BOTTOM = Color(hex: "#F8F3EE")
private let INK       = Color(hex: "#0F696F")
private let SAGE      = Color(hex: "#A5A58D")
private let ACCENT    = Color(hex: "#CB997E")
private let CARD_BG   = Color.white

// MARK: - Models


// MARK: - Root screen
struct Allergy: View {
    

    let fabrics: [FabricInfo] = [
            FabricInfo(name: "Cotton",    composition: "100% Cotton",    score: 8.0, bestTempRangeC: "22–30", suitableForBabies: true,  notes: "Cotton is generally safe and won’t irritate the skin, even in hot weather."),
            FabricInfo(name: "Polyester", composition: "100% Polyester", score: 3.0, bestTempRangeC: "16–22", suitableForBabies: false, notes: "Low airflow; can trap heat and sweat against the skin."),
            FabricInfo(name: "Linen",     composition: "100% Linen",     score: 9.0, bestTempRangeC: "25–35", suitableForBabies: true,  notes: "Very breathable; stays comfy in heat thanks to high breathability.")
        ]

    var body: some View {
        AllergyWarningSheet(fabrics: fabrics)
        }
    }


// MARK: - Allergy Warning Sheet
struct AllergyWarningSheet: View {
    let fabrics: [FabricInfo]
    @State private var selectedFabric: FabricInfo

    init(fabrics: [FabricInfo]) {
        self.fabrics = fabrics
        _selectedFabric = State(initialValue: fabrics.first!)
    }

    private var isSafe: Bool {
        selectedFabric.name == "Cotton" || selectedFabric.name == "Linen"
    }
    private var statusText: String { isSafe ? "Safe on skin" : "Use with caution" }
    private var statusIcon: String { isSafe ? "checkmark.seal.fill" : "exclamationmark.triangle.fill" }
    private var statusColor: Color { isSafe ? SAGE : ACCENT }

    var body: some View {
        ZStack {
            LinearGradient(colors: [BG_TOP, BG_BOTTOM], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    // Fabric picker
                    Picker("Fabric Type", selection: $selectedFabric) {
                        ForEach(fabrics, id: \.self) { fabric in
                            Text(fabric.name).tag(fabric)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(INK)
                    .padding(.horizontal)

                    // Status pill
                    HStack {
                        StatusPill(text: statusText, systemImage: statusIcon, tint: statusColor)
                        Spacer()
                    }
                    .padding(.horizontal)

                    // Notes card
                    InfoCard(
                        title: "Notes",
                        icon: "info.circle",
                        iconTint: INK
                    ) {
                        Text(selectedFabric.notes)
                            .foregroundColor(INK.opacity(0.95))
                            .font(.body.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)

                    // Avoid if card (full width)
                    InfoCard(
                        title: "Avoid if",
                        icon: "hand.raised.fill",
                        iconTint: ACCENT
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            allergyWarnings(for: selectedFabric.name)
                        }
                        .foregroundColor(INK.opacity(0.9))
                        .font(.subheadline)
                    }
                    .padding(.horizontal)

                    // General note card to fill space
                    InfoCard(
                        title: "General Safety Note",
                        icon: "heart.text.square",
                        iconTint: SAGE
                    ) {
                        Text("Always patch-test fabrics if you have sensitive skin. Avoid tight fits in hot weather.")
                            .foregroundColor(INK.opacity(0.9))
                            .font(.footnote)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 12)
                }
                .padding(.top, 10)
                .navigationTitle("Possible Allergies!")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    @ViewBuilder
    private func allergyWarnings(for fabricName: String) -> some View {
        switch fabricName {
        case "Polyester":
            Text("• High-intensity workouts")
            Text("• Hot & humid weather")
            Text("• Prolonged wear without ventilation")
        case "Cotton", "Linen":
            Text("• Known fabric sensitivities")
            Text("• Heavily dyed/treated garments")
        default:
            Text("• Use with caution")
        }
    }
}

// MARK: - UI Helpers
private struct StatusPill: View {
    let text: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(text)
                .font(.subheadline.weight(.semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(tint)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }
}

private struct InfoCard<Content: View>: View {
    let title: String
    let icon: String
    let iconTint: Color
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(iconTint)
                Text(title)
                    .font(.headline)
                    .foregroundColor(INK)
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CARD_BG)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

// MARK: - Preview
#Preview {
    Allergy()
}
