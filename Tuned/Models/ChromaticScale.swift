//
//  ChromaticScale.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import Foundation

struct ChromaticScale {
    
    enum Semitone {
        case c(Int)
        case cSharp(Int)
        case d(Int)
        case dSharp(Int)
        case e(Int)
        case f(Int)
        case fSharp(Int)
        case g(Int)
        case gSharp(Int)
        case a(Int)
        case aSharp(Int)
        case b(Int)
    }
    
    static func note(for semitone: Semitone) -> Note {
        switch semitone {
        case .c(let octave):
            return Note(name: "C", baseFrequency: 16.35, octave: octave)
        case .cSharp(let octave):
            return Note(name: "C♯", baseFrequency: 17.32, octave: octave)
        case .d(let octave):
            return Note(name: "D", baseFrequency: 18.35, octave: octave)
        case .dSharp(let octave):
            return Note(name: "D♯", baseFrequency: 19.45, octave: octave)
        case .e(let octave):
            return Note(name: "E", baseFrequency: 20.6, octave: octave)
        case .f(let octave):
            return Note(name: "F", baseFrequency: 21.83, octave: octave)
        case .fSharp(let octave):
            return Note(name: "F♯", baseFrequency: 23.12, octave: octave)
        case .g(let octave):
            return Note(name: "G", baseFrequency: 24.5, octave: octave)
        case .gSharp(let octave):
            return Note(name: "G♯", baseFrequency: 25.96, octave: octave)
        case .a(let octave):
            return Note(name: "A", baseFrequency: 27.5, octave: octave)
        case .aSharp(let octave):
            return Note(name: "A♯", baseFrequency: 29.14, octave: octave)
        case .b(let octave):
            return Note(name: "B", baseFrequency: 30.87, octave: octave)
        }
    }
}
