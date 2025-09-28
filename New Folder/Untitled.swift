//
//  Untitled.swift
//  Naseej
//
//  Created by Fajer alQahtani on 03/04/1447 AH.
//

import SwiftUI

struct watertracker: View {
    @State private var remindersOn = false
    var body: some View {
        VStack {
            Image(systemName: "")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Water Tracker 💧 ")
            
            Toggle(isOn: $remindersOn ) {
                Text("Apple health")
            }
            Stepper(value: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(4)/*@END_MENU_TOKEN@*/, in: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Range@*/1...10/*@END_MENU_TOKEN@*/) {
                Text("Cups to drink per day 0")
            }

        }
        Button("Continue") {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

