//
//  ContentView.swift
//  Naseej
//
//  Created by Fajer alQahtani on 03/04/1447 AH.
//

import SwiftUI

// MARK: - Breathability Sheet (drop-in)
struct BreathabilitySheet: View {
    @State private var selectedIndex: Int = 0

    // Palette (RGB to avoid hex helpers)
    private let ink      = Color(red: 15/255,  green: 105/255, blue: 111/255)  // #0F696F
    private let text2    = Color(red: 107/255, green: 112/255, blue: 92/255)   // #6B705C
    private let bg       = Color(red: 217/255, green: 229/255, blue: 228/255)  // #D9E5E4

    // Simple fabric model (local, so it won’t conflict with your other types)
    struct BFabric: Identifiable {
        let id = UUID()
        let name: String
        let composition: String
        let score: Double
        let bestTempRangeC: String
        let suitableForBabies: Bool
        let notes: String
    }

    // Demo data (you can remove when you wire real scan data)
    private let fabrics: [BFabric] = [
        .init(name: "Cotton",    composition: "100% Cotton",    score: 8.0, bestTempRangeC: "22–30", suitableForBabies: true,  notes: "Breathable, absorbs sweat."),
        .init(name: "Polyester", composition: "100% Polyester", score: 3.0, bestTempRangeC: "16–22", suitableForBabies: false, notes: "Low airflow, traps heat."),
        .init(name: "Linen",     composition: "100% Linen",     score: 9.0, bestTempRangeC: "25–35", suitableForBabies: true,  notes: "Very breathable, dries fast.")
    ]

    private var fabric: BFabric { fabrics[selectedIndex] }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Title + subtitle
            VStack(alignment: .leading, spacing: 6) {
                Text("Breathability")
                    .font(.title.bold())
                    .foregroundColor(ink)
                Text("How well this fabric lets air flow.")
                    .font(.caption)
                    .foregroundColor(ink.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Temporary selector while testing
            Picker("Fabric", selection: $selectedIndex) {
                ForEach(fabrics.indices, id: \.self) { i in
                    Text(fabrics[i].name).tag(i)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)

            // Gauge
            HStack { Spacer()
                BCircle(score: fabric.score, tint: ink, number: text2)
                    .padding(.top, 6)
                Spacer()
            }

            // Status pill
            HStack { Spacer()
                BPill(text: statusText(for: fabric.score))
                    .foregroundColor(.primary)
                Spacer()
            }

            // Notes pill (with small icon)
            HStack { Spacer()
                BNote(text: fabric.notes, tint: ink)
                Spacer()
            }

            // Three cards
            HStack(spacing: 14) {
                BCard(title: "Best for \(fabric.bestTempRangeC) °C", icon: "thermometer")
                BCard(title: fabric.suitableForBabies ? "Suitable for babies" : "Not ideal for babies",
                      icon: "figure.and.child.holdinghands")
                BCard(title: "Higher airflow", icon: "wind")
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer(minLength: 24)
        }
        .background(bg.ignoresSafeArea())
        // Optional: set the sheet sizes and drag indicator
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func statusText(for score: Double) -> String {
        switch score {
        case ..<3:  return "Low breathability"
        case 3..<7: return "Moderately breathable"
        default:    return "Highly breathable"
        }
    }
}

// MARK: - Small components (names prefixed to avoid clashes)

private struct BPill: View {
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

private struct BNote: View {
    var text: String
    var tint: Color
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 15))
                .foregroundColor(tint)
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

private struct BCard: View {
    var title: String
    var icon: String
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(red: 15/255, green: 105/255, blue: 111/255))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(16)

            Image(systemName: icon)
                .font(.system(size: 34))
                .foregroundColor(.black.opacity(0.12))
                .padding(12)
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.black.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 3)
    }
}

private struct BCircle: View {
    var score: Double
    var maxScore: Double = 10
    var lineWidth: CGFloat = 14
    var size: CGFloat = 140
    var tint: Color
    var number: Color

    private var progress: CGFloat { CGFloat(min(max(score / maxScore, 0), 1)) }

    var body: some View {
        ZStack {
            Circle().stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.1f", score))
                .font(.system(size: size * 0.22, weight: .bold))
                .foregroundColor(number)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    BreathabilitySheet()
}
