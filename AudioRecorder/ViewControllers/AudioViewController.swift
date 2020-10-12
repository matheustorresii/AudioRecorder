//
//  AudioViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit

class AudioViewController: UIViewController {
    
    var audio: Audio!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        titleLabel.text = audio.title
        timeLabel.text = audio.length
    }
}
