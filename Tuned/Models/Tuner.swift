//
//  Tuner.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import Foundation
import AudioKit
import SoundpipeAudioKit
import AudioToolbox

protocol TunerDelegate: AnyObject {
    func tuner(_ tuner: Tuner, didReceive data: TunerData)
}

struct TunerData {
    var pitch: Float = 0.0
    var note: Note?
    var pitchDifference: Float?
}

class Tuner {
    
    let tuning: TuningStrategy
    var data = TunerData()
    
    weak var delegate: TunerDelegate?
    
    let engine = AudioKit.AudioEngine()
    let microphone: AudioEngine.InputNode
    var pitchTracker: PitchTap!
    
    init(_ tuning: TuningStrategy) {
        self.tuning = tuning
        guard let input = engine.input, engine.inputDevice != nil else {
            // TODO: Improve error handling by displaying an alert to the user
            return
        }
        microphone = input
        engine.output = input // Engine needs an output to initialize
        pitchTracker = PitchTap(microphone) { pitch, amplitude in
            let firstPitch = pitch.first ?? 0
            let firstAmplitude = amplitude.first ?? 0
            self.updateData(pitch: firstPitch, amplitude: firstAmplitude)
        }
    }
    
    func startTuning() {
        do {
            try engine.start()
            pitchTracker.start()
        } catch {
            // TODO: Improve error handling by displaying an alert to the user
            fatalError("Failed to start Tuner: \(error.localizedDescription)")
        }
    }
    
    func stopTuning() {
        engine.stop()
    }

    func updateData(pitch: AUValue, amplitude: AUValue) {
        guard amplitude > 0.1 else {
            data = TunerData()
            delegate?.tuner(self, didReceive: data)
            return
        }
        
        var nearestSemitoneIndex = 0
        for index in 0..<tuning.semitones.count {
            let note = ChromaticScale.note(for: tuning.semitones[index])
            if pitch > Float(note.frequency) {
                nearestSemitoneIndex = index
            }
        }
        
        if nearestSemitoneIndex + 1 < tuning.semitones.count {
            let lowerNote = ChromaticScale.note(for: tuning.semitones[nearestSemitoneIndex])
            let higherNote = ChromaticScale.note(for: tuning.semitones[nearestSemitoneIndex + 1])
            let midpoint: Float = Float(lowerNote.frequency + higherNote.frequency) / 2
            
            if pitch > midpoint {
                nearestSemitoneIndex += 1
            }
        }
        
        let nearestSemitone = tuning.semitones[nearestSemitoneIndex]
        let note = ChromaticScale.note(for: nearestSemitone)
        
        let pitchDifference = pitch - Float(note.frequency)
        
        data.pitch = pitch
        data.note = note
        data.pitchDifference = pitchDifference
        
        delegate?.tuner(self, didReceive: data)
    }
}
