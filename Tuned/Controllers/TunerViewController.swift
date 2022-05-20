//
//  TunerViewController.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import UIKit

class TunerViewController: UIViewController {

    @IBOutlet weak var tuningDisplay: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var baseNoteLabel: UILabel!
    @IBOutlet weak var pitchNoteLabel: UILabel!
    @IBOutlet weak var baseCircle: UIImageView!
    @IBOutlet weak var inTuneCircle: UIImageView!
    
    var tuner: Tuner?
    var animatingDidTuneNote = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTuner()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

// MARK: - Tuner Methods
extension TunerViewController: TunerDelegate {
    
    func setupTuner() {
        do {
            try tuner = Tuner(StandardTuning())
            tuner?.delegate = self
            try tuner?.startTuning()
        } catch TunerError.failedToInitialize {
            showError("Something wen't wrong!")
        } catch TunerError.failedToStart {
            showError("Something wen't wrong!")
        } catch TunerError.microphoneAccessDenied {
            showError("Tuned can't access your microphone.")
        } catch {
            showError("Something wen't wrong!")
        }
    }
    
    func tuner(_ tuner: Tuner, didReceive data: TunerData) {
        guard let note = data.note, let pitchDifference = data.pitchDifference else {
            resetDisplay()
            return
        }
        updateDisplay(noteName: note.name, pitchDifference: pitchDifference)
        if abs(pitchDifference) < 1 {
            didTuneNote()
        }
    }
}

// MARK: - TuningDisplay Methods
extension TunerViewController {
    
    func resetDisplay() {
        baseNoteLabel.text = ""
        pitchNoteLabel.text = ""
        pitchNoteLabel.transform = .identity
    }
    
    func updateDisplay(noteName: String, pitchDifference: Float) {
        baseNoteLabel.text = noteName
        pitchNoteLabel.text = noteName
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.pitchNoteLabel.transform = CGAffineTransform(
                translationX: CGFloat(pitchDifference * abs(pitchDifference)),
                y: 0
            )
        }
    }
    
    func didTuneNote() {
        guard !animatingDidTuneNote else { return }
        animatingDidTuneNote = true
        
        inTuneCircle.transform = CGAffineTransform(scaleX: 0, y: 0)
        inTuneCircle.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.inTuneCircle.alpha = 0.25
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn) {
            self.inTuneCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { complete in
            self.animatingDidTuneNote = false
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.6) {
            self.inTuneCircle.alpha = 0
        }
    }
}
