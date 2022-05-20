//
//  TunerViewController.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/19/22.
//

import UIKit

class TunerViewController: UIViewController {

    @IBOutlet weak var noteLabel: UILabel!
    let tuner = Tuner(StandardTuning())

    override func viewDidLoad() {
        super.viewDidLoad()
        tuner.delegate = self
        tuner.startTuning()
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
