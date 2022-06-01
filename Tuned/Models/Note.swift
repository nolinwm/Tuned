//
//  Note.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import Foundation

struct Note {
    let name: String
    let baseFrequency: Double
    let octave: Int
    
    var frequency: Double {
        return baseFrequency * pow(2, Double(octave))
    }
}
