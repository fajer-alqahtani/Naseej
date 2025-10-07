//
//  Style.swift
//  Naseej
//
//  Created by Fajer alQahtani on 14/04/1447 AH.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
var cornerRadius: CGFloat = 15
    
func makeBody(configuration: Configuration) -> some View {
        configuration.label
.font(.subheadline)
.foregroundColor(Color(red: 15/255, green: 105/255, blue: 111/255))
.frame(maxWidth: .infinity, minHeight: 115)
.padding(.vertical, 16)
.background(
Color(red: 244/255, green: 244/255, blue: 238/255)
.opacity(configuration.isPressed ? 0.7 : 1)             )
.cornerRadius(cornerRadius)
.shadow(color: .gray.opacity(0.5),
radius: configuration.isPressed ? 0 : 4,
x: 0,
y: configuration.isPressed ? 0 : 4)
.scaleEffect(configuration.isPressed ? 0.97 : 1)
.animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
