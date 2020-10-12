//
//  AudioCell.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit

class AudioCell: UITableViewCell {
    
    var parentController: UIViewController!
    var audio: Audio!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func playAudio(_ sender: Any) {
        let audioViewController = parentController.storyboard!.instantiateViewController(identifier: "AudioViewController") as? AudioViewController
        audioViewController!.audio = audio
        parentController.present(audioViewController!, animated: true, completion: nil)
    }
}
