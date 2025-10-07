//
//  ContentView.swift
//  nassej
//
//  Created by Feda  on 26/09/2025.
//
import SwiftUI

// تعريف الألوان داخل الكود
let BG_COLOR = Color(red: 218/255, green: 232/255, blue: 230/255)   // لون الخلفية الأساسي
let PRIMARY_COLOR = Color(red: 15/255, green: 105/255, blue: 111/255) // اللون الأساسي للأزرار والعناوين


struct CareContentView: View {
    var body: some View {
        ZStack {
            // نفس الخلفية في الـ Sheet
            BG_COLOR.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // صورة الخلفية
                Image("Image 1")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 8)
                
                // العنوان الرئيسي
                Text("Care Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(PRIMARY_COLOR)
                    .padding(.trailing, 30)
                
                // الكروت
                HStack(spacing: 16) {
                    CareCard(
                        title: "washing:",
                        description: "wash cold, gentle cycle.\nDo not bleach.",
                        iconName: "Image 2",
                        titleColor: PRIMARY_COLOR
                    )
                    
                    CareCard(
                        title: "drying:",
                        description: "Tumble dry low\nor air dry.",
                        iconName: "Image 5",
                        titleColor: PRIMARY_COLOR
                    )
                    
                    CareCard(
                        title: "ironing:",
                        description: "Low iron if\nneeded.",
                        iconName: "Image 4",
                        titleColor: PRIMARY_COLOR
                    )
                }
                .padding(.top, 2.0)
                
                Spacer()
            }
        }
    }
}

struct CareCard: View {
    let title: String
    let description: String
    let iconName: String
    var titleColor: Color = .black
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 110, height: 160)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 6) {
                // العنوان
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(titleColor)
                
                // الوصف
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                // الأيقونة
                Image(iconName)
                    .resizable()
                    .renderingMode(.template) // لو تبغى تغير لون الأيقونة
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(titleColor)
                    .padding(.bottom, 6)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .frame(width: 110, height: 160, alignment: .topLeading)
        }
    }
}

#Preview {
    CareContentView()
}
