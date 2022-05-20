//
//  TuningStrategy.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import Foundation

protocol TuningStrategy {
    var name: String { get }
    var semitones: [ChromaticScale.Semitone] { get }
}

struct StandardTuning: TuningStrategy {
    var name = "Standard"
    var semitones = [
        ChromaticScale.Semitone.e(2),
        ChromaticScale.Semitone.a(2),
        ChromaticScale.Semitone.d(3),
        ChromaticScale.Semitone.g(3),
        ChromaticScale.Semitone.b(3),
        ChromaticScale.Semitone.e(4)
    ]
}
