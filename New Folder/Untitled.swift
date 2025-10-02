//
//  Untitled.swift
//  Naseej
//
//  Created by Fajer alQahtani on 03/04/1447 AH.
//
import SwiftUI


struct watertracker: View {
    @State private var remindersOn = false
    @State  var numOfcups = 0
    func incrementCups(){
        numOfcups += 1
    }
    func decrementCups(){
        numOfcups -= 1
    }
    var body: some View {
        VStack {
            Image(systemName: "")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Water Tracker 💧 ")
            
            Toggle(isOn: $remindersOn ) {
                Text("Apple health")
            }
            Stepper() {
                Text("Cups to drink per day " + String(numOfcups) )
                
            }
            onIncrement: {
              incrementCups()
            }  onDecrement:{
                 decrementCups()
            }

        }
        Button("Continue") {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
        }
        .padding()
    }
}

//#Preview {
  //  watertracker()
//}


