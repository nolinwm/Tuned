//
//  Tuner.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import Foundation
import AVFoundation
import AudioKit
import SoundpipeAudioKit
import AudioToolbox

protocol TunerDelegate: AnyObject {
    func tuner(_ tuner: Tuner, didReceive data: TunerData)
}

enum TunerError: Error {
    case failedToInitialize
    case failedToStart
    case microphoneAccessDenied
}

struct TunerData {
    var pitch: Float = 0.0
    var note: Note?
    var pitchDifference: Float?
}

class Tuner {
    
    var tuning: TuningStrategy
    var data = TunerData()
    
    weak var delegate: TunerDelegate?
    
    let engine = AudioKit.AudioEngine()
    var microphone: AudioEngine.InputNode
    var pitchTracker: PitchTap!
    
    init(_ tuning: TuningStrategy) throws {
        guard let input = engine.input, engine.inputDevice != nil else {
            throw TunerError.failedToInitialize
        }
        self.tuning = tuning
        microphone = input
        engine.output = input // Engine needs an output to initialize
        pitchTracker = PitchTap(microphone) { pitch, amplitude in
            let firstPitch = pitch.first ?? 0
            let firstAmplitude = amplitude.first ?? 0
            self.updateData(pitch: firstPitch, amplitude: firstAmplitude)
        }
    }
    
    func startTuning() throws {
        /*
            This presents an issue in that when recordPermission is undetermined, like
            when opening the app for the first time, it throws a denied error before giving
            the user a chance to allow.
            // TODO: Better handling of microphone access
         */
    
        guard AVAudioSession.sharedInstance().recordPermission == .granted else {
            throw TunerError.microphoneAccessDenied
        }
        do {
            try engine.start()
            pitchTracker.start()
        } catch {
            throw TunerError.failedToStart
        }
    }
    
    func stopTuning() {
        engine.stop()
        pitchTracker.stop()
    }

    private func updateData(pitch: AUValue, amplitude: AUValue) {
        guard amplitude > 0.2 else {
            data = TunerData()
            delegate?.tuner(self, didReceive: data)
            return
        }
        
        let semitone = nearestSemitone(for: pitch, in: tuning)
        let note = ChromaticScale.note(for: semitone)
        let pitchDifference = pitch - Float(note.frequency)
        
        data.pitch = pitch
        data.note = note
        data.pitchDifference = pitchDifference
        
        delegate?.tuner(self, didReceive: data)
    }
    
    private func nearestSemitone(for pitch: Float, in tuning: TuningStrategy) -> ChromaticScale.Semitone {
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
        
        return tuning.semitones[nearestSemitoneIndex]
    }
}
