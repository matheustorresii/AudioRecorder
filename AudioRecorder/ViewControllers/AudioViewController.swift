//
//  AudioViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit

class AudioViewController: UIViewController {
    
    var audio: Audio!
    
    var isPlaying: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioBackend.sharedInstance.setupAudio(with: audio.identifier)
    }
    
    func setupLayout() {
        titleLabel.text = audio.title
        timeLabel.text = audio.length
    }
    
    @IBAction func play(_ sender: Any) {
        if isPlaying {
            actionButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            AudioBackend.sharedInstance.pause()
        } else {
            actionButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            AudioBackend.sharedInstance.start()
        }
        isPlaying = !isPlaying
    }
}
