//
//  StartPage.swift
//  Naseej
//
//  Created by Fajer alQahtani on 13/04/1447 AH.
//

import SwiftUI

struct WelcomeView: View {
@State private var isActive = false
@State private var showText = false
    
var body: some View {
NavigationStack {
if isActive {
SCANContentView()
} else {
ZStack {
Color(red: 0xAD/255, green: 0xC9/255, blue: 0xCD/255)
.ignoresSafeArea()
                    
Image("خلفية الشاشة 1")
.resizable()
.scaledToFill()
.ignoresSafeArea()
.opacity(0.8)
                    
VStack(spacing: 20) {
Spacer()
                        
Text("Welcome to").font(.system(size: 36, weight: .bold, design: .rounded))
.foregroundColor(.white)
.shadow(radius: 6)
.opacity(showText ? 1 : 0)
.scaleEffect(showText ? 1 : 0.7)
.animation(.easeOut(duration: 1), value: showText)
                        
                        
Text("Naseej")
.font(.system(size: 44, weight: .heavy, design: .rounded))
.foregroundColor(.white)
.shadow(radius: 10)
.opacity(showText ? 1 : 0)
.scaleEffect(showText ? 1 : 0.7)
.animation(.easeOut(duration: 1).delay(0.5), value: showText)
                        
Text("Ready to check your clothes?")
.font(.custom("BahijTheSansArabic-Bold", size: 20))
.bold()
.foregroundColor(.white.opacity(0.9))
.multilineTextAlignment(.center)
.padding(.horizontal, 40)
.padding(.top, 20)
.opacity(showText ? 1 : 0)
.animation(.easeOut(duration: 1).delay(1), value: showText)


                        
Spacer()
                    }
                }
.onAppear {
                
                    showText = true
                    
        
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct WelcomContentView: View {
    var body: some View {
        Text("This is ContentView")
            .font(.largeTitle)
            .foregroundColor(.black)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
