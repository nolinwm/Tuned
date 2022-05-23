//
//  SelectTuningViewController.swift
//  Tuned
//
//  Created by Nolin McFarland on 5/23/22.
//

import UIKit

class SelectTuningViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tunings: [TuningStrategy] = [
        StandardTuning(), DropDTuning(),
        HalfStepDownTuning(), FullStepDownTuning()
    ]
    var initialTuning: TuningStrategy?
    var selectedIndexPath: IndexPath?
    
    var completion: (TuningStrategy) -> () = { tuning in }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<tunings.count {
            if tunings[index].name == initialTuning?.name {
                selectedIndexPath = IndexPath(row: index, section: 0)
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion(tunings[selectedIndexPath?.row ?? 0])
    }
}

extension SelectTuningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tunings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuningCell")!
        let tuning = tunings[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(1) as? UILabel {
            nameLabel.text = tuning.name
        }
        
        if let stringsLabel = cell.viewWithTag(2) as? UILabel {
            stringsLabel.text = ""
            for semitone in tuning.semitones {
                let note = ChromaticScale.note(for: semitone)
                stringsLabel.text! += "\(note.name) "
            }
            stringsLabel.text = String(stringsLabel.text!.dropLast())
        }
        
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath != selectedIndexPath else { return }
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
}
