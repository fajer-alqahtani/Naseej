//
//  ContentView.swift
//  Naseej
//
//  Created by Fajer alQahtani on 03/04/1447 AH.
//

import SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // skip #
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

struct BreathabilityCircle: View {
    var score: Double
    var maxScore: Double = 10
    var lineWidth: CGFloat = 12
    var size: CGFloat = 120

    private var progress: CGFloat {
        CGFloat(score / maxScore)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color(hex: "#CB997E"),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text(String(format: "%.1f", score))
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "#6B705C"))
        }
        .frame(width: size, height: size)
    }
}


struct ContentView: View {
    @State private var score = 5.0
    @State private var remindersOn = false
    var body: some View {
        VStack {
            Text("Breathability")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#0F696F"))
                .padding(.top , -270)
            
                
            Text("How well this fabric lets air flow.")
                .font(.caption)
                .foregroundColor(Color(hex: "#0F696F"))
                .padding(.top , -255)
            
            BreathabilityCircle(score: score)
                .padding(.top , -200)
            
            Text("Moderately breathable")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#0F696F"))
                .padding(.top , -60)
                

            
            GroupBox() {
               Text("")
            }

        }
        .padding()
    }
}

struct RateCircle: View {
    var score: Double            // e.g. 5.0
    var maxScore: Double = 10.0
    var lineWidth: CGFloat = 12
    var size: CGFloat = 130

    private var progress: CGFloat {
        let p = score / maxScore
        return CGFloat(min(max(p, 0), 1))
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            // Progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color(hex: "#CB997E"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // start at top
                .animation(.easeOut(duration: 0.6), value: progress)

            // Number
            Text(String(format: "%.1f", score))
                .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#6B705C"))
        }
        .frame(width: size, height: size)
    }
}

 #Preview {
 ContentView()
}

