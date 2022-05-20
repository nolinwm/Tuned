//
//  TunerViewController.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import UIKit

class TunerViewController: UIViewController {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    var tuner: Tuner?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTuner()
    }
    
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
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

extension TunerViewController: TunerDelegate {
    func tuner(_ tuner: Tuner, didReceive data: TunerData) {
        guard let note = data.note, let pitchDifference = data.pitchDifference else {
            noteLabel.text = nil
            return
        }
        noteLabel.text = note.name
        print(pitchDifference)
    }
}
