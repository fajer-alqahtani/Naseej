//
//  ContentView.swift
//  Naseej
//
//  Created by Fajer alQahtani on 03/04/1447 AH.
//

import SwiftUI


// MARK: - Helpers
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Gauge
struct BreathabilityCircle: View {
    var score: Double
    var maxScore: Double = 10
    var lineWidth: CGFloat = 12
    var size: CGFloat = 120

    private var progress: CGFloat { CGFloat(min(max(score / maxScore, 0), 1)) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(hex: "#0F696F"),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text(String(format: "%.1f", score))
                .font(.system(size: size * 0.22, weight: .bold))
                .foregroundColor(Color(hex: "#6B705C"))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Reusable views
struct InfoPill: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
    }
}

struct NotePill: View {
    var text: String
    var icon: String = "info.circle"
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#0F696F"))
            Text(text)
                .font(.subheadline)
                .foregroundColor(.black)
                .lineLimit(2)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Mini Card (BIGGER)
struct MiniInfoCard: View {
    var title: String
    var icon: String
    var tint: Color = .white

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline) // was subheadline
                    .foregroundColor(Color(hex: "#0F696F"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(16) // was 14

            // Larger watermark icon
            Image(systemName: icon)
                .font(.system(size: 34))       // was 28
                .foregroundColor(.black.opacity(0.12))
                .padding(12)                    // was 10
        }
        .frame(height: 150)                      // was 128
        .frame(maxWidth: .infinity)
        .background(tint)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) // was 14
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.black.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 3)
    }
}

// MARK: - Sample data
struct FabricInfo: Identifiable {
    let id = UUID()
    let name: String
    let composition: String
    let score: Double
    let bestTempRangeC: String
    let suitableForBabies: Bool
    let notes: String
}

let sampleFabrics: [FabricInfo] = [
    .init(name: "Cotton", composition: "100% Cotton", score: 8.0,
          bestTempRangeC: "22–30", suitableForBabies: true,
          notes: "Breathable, absorbs sweat."),
    .init(name: "Polyester", composition: "100% Polyester", score: 3.0,
          bestTempRangeC: "16–22", suitableForBabies: false,
          notes: "Low airflow, traps heat."),
    .init(name: "Linen", composition: "100% Linen", score: 9.0,
          bestTempRangeC: "25–35", suitableForBabies: true,
          notes: "Very breathable, dries fast.")
]

// MARK: - Screen
struct ContentView: View {
    @State private var showingBottomSheet = false
    @State private var selectedIndex: Int = 0
    private var fabric: FabricInfo { sampleFabrics[selectedIndex] }

    var body: some View {
        VStack {
            Button("Breathability") {
                showingBottomSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $showingBottomSheet) {
            VStack(alignment: .leading, spacing: 20) { // + more vertical spacing

                // Title + subtitle
                VStack(alignment: .leading, spacing: 6) {
                    Text("Breathability")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#0F696F"))
                    Text("How well this fabric lets air flow.")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#0F696F").opacity(0.8))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Selector (keep while testing)
                Picker("Fabric", selection: $selectedIndex) {
                    ForEach(sampleFabrics.indices, id: \.self) { i in
                        Text(sampleFabrics[i].name).tag(i)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)

                // Gauge — bigger
                HStack {
                    Spacer()
                    BreathabilityCircle(score: fabric.score,
                                        maxScore: 10,
                                        lineWidth: 14,   // thicker
                                        size: 140)       // larger
                    Spacer()
                }
                .padding(.top, 6)

                // Status pill
                HStack { Spacer(); InfoPill(text: statusText(for: fabric.score)); Spacer() }

                // Notes pill
                HStack { Spacer(); NotePill(text: fabric.notes); Spacer() }

                // Bigger cards + more breathing room
                HStack(spacing: 14) { // was 12
                    MiniInfoCard(
                        title: "Best for \(fabric.bestTempRangeC) °C",
                        icon: "thermometer"
                    )
                    MiniInfoCard(
                        title: fabric.suitableForBabies ? "Suitable for babies" : "Not ideal for babies",
                        icon: "figure.and.child.holdinghands"
                    )
                    MiniInfoCard(
                        title: "Higher airflow",
                        icon: "wind"
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)   // bring closer to pills

                Spacer(minLength: 24) // more bottom space
            }
            .background(Color(hex: "#D9E5E4").ignoresSafeArea())
        }
    }

    private func statusText(for score: Double) -> String {
        switch score {
        case ..<3:  return "Low breathability"
        case 3..<7: return "Moderately breathable"
        default:    return "Highly breathable"
        }
    }
}

#Preview {
    ContentView()
}
