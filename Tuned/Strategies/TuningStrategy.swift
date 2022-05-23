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

struct DropDTuning: TuningStrategy {
    var name = "Drop D"
    var semitones = [
        ChromaticScale.Semitone.d(2),
        ChromaticScale.Semitone.a(2),
        ChromaticScale.Semitone.d(3),
        ChromaticScale.Semitone.g(3),
        ChromaticScale.Semitone.b(3),
        ChromaticScale.Semitone.e(4)
    ]
}

struct HalfStepDown: TuningStrategy {
    var name = "Half Step Down"
    var semitones = [
        ChromaticScale.Semitone.dSharp(2),
        ChromaticScale.Semitone.gSharp(2),
        ChromaticScale.Semitone.cSharp(3),
        ChromaticScale.Semitone.fSharp(3),
        ChromaticScale.Semitone.aSharp(3),
        ChromaticScale.Semitone.dSharp(4)
    ]
}

struct FullStepDown: TuningStrategy {
    var name = "Full Step Down"
    var semitones = [
        ChromaticScale.Semitone.d(2),
        ChromaticScale.Semitone.g(2),
        ChromaticScale.Semitone.c(3),
        ChromaticScale.Semitone.f(3),
        ChromaticScale.Semitone.a(3),
        ChromaticScale.Semitone.d(4)
    ]
}
