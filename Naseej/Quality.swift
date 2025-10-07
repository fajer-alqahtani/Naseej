//
//  Quality.swift
//  Naseej
//
//  Created by Fajer alQahtani on 13/04/1447 AH.
//

import SwiftUI

// Hex color helper (renamed so it won't collide with other files)
private extension Color {
    init(hexRGB: String) {
        let s = Scanner(string: hexRGB)
        _ = s.scanString("#")
        var v: UInt64 = 0
        s.scanHexInt64(&v)
        self.init(.sRGB,
                  red:   Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >>  8) & 0xFF) / 255,
                  blue:  Double(v & 0xFF) / 255,
                  opacity: 1)
    }
}

// Reusable palette
private let BG_BASE   = Color(hexRGB: "#D9E5E4")   // app background
private let BG_TOP    = Color(hexRGB: "#E7F0EF")   // sheet gradient top
private let BG_BOTTOM = Color(hexRGB: "#F8F3EE")   // sheet gradient bottom
private let INK       = Color(hexRGB: "#0F696F")   // headings / buttons
private let ACCENT    = Color(hexRGB: "#CB997E")   // warm accent (optional)
private let SAGE      = Color(hexRGB: "#A5A58D")   // icon tint



struct  Quality: View {
    var body: some View {
        ZStack {
            // Soft gradient like your info page
            LinearGradient(colors: [BG_TOP, BG_BOTTOM], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // Decorative background globe (very subtle)
            VStack {
                Spacer()
                Image(systemName: "globe.americas.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 420)
                    .opacity(0.07)
                    .offset(x: 40, y: 100)
            }

            // Content
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Quality")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(INK)

                // Composition lines
                VStack(alignment: .leading, spacing: 6) {
                    Text("94% Polyester")
                    Text("6% Elastane")
                }
                .font(.title3.weight(.semibold))
                .foregroundColor(INK)

                // Section: Environmental impact
                Text("ENVIRONMENTAL IMPACT:")
                    .font(.headline.weight(.bold))
                    .foregroundColor(INK)

                HStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(SAGE)
                    Text("Eco Score: 4.5 / 10")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(INK)
                }

                HStack(spacing: 12) {
                    Image(systemName: "arrow.3.trianglepath")
                        .foregroundColor(SAGE)
                    Text("Sustainability: 3.0 / 10")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(INK)
                }

                Spacer()

                // Summary card
                HStack {
                    VStack(spacing: 6) {
                        Image(systemName: "leaf")
                            .foregroundColor(SAGE)
                        Text("0%")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(INK)
                    }

                    Spacer()

                    VStack(spacing: 6) {
                        Text("100% Synthetic")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(INK)
                        // Optional accent chip:
                        Text("Lower durability vs. natural fibers")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(INK.opacity(0.85))
                            .clipShape(Capsule())
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 120)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    Quality()
}
