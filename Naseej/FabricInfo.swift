//
//  FabricInfo.swift
//  Naseej
//
//  Created by Fajer alQahtani on 13/04/1447 AH.
//

import Foundation

struct FabricInfo: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let composition: String
    let score: Double
    let bestTempRangeC: String
    let suitableForBabies: Bool
   let notes: String
}
