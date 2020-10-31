//
//  AudioViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audio: Audio!
    var time: TimeInterval = 0
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = audio.title
        }
    }

    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = audio.length
        }
    }
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioBackend.sharedInstance.setupAudio(with: audio.identifier, from: self)
        let audioDuration = AudioBackend.sharedInstance.getTotalDuration()
        timeSlider.maximumValue = Float(audioDuration)
        time = AudioBackend.sharedInstance.getCurrentTime()
        Timer.scheduledTimer(timeInterval: 0.1,
                                   target: self,
                                 selector: #selector(updateSlider(_:)),
                                 userInfo: nil,
                                  repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioBackend.sharedInstance.stop()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func play(_ sender: Any) {
        if AudioBackend.sharedInstance.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction func goForward(_ sender: Any) {
        time = AudioBackend.sharedInstance.getCurrentTime() + 3.0
        timeSlider.value += 3
        resetTimer()
        resume()
    }
    
    @IBAction func goBackward(_ sender: Any) {
        time = AudioBackend.sharedInstance.getCurrentTime() - 3.0
        timeSlider.value -= 3
        resetTimer()
        resume()
    }
    
    func resume() {
        if AudioBackend.sharedInstance.isPlaying {
            play()
        }
    }
    
    func pause() {
        actionButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        AudioBackend.sharedInstance.pause()
        time = AudioBackend.sharedInstance.getCurrentTime()
    }
    
    func play() {
        actionButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        AudioBackend.sharedInstance.play(at: time)
        if AudioBackend.sharedInstance.getCurrentTime() == 0.0 || AudioBackend.sharedInstance.getCurrentTime() == AudioBackend.sharedInstance.getTotalDuration() {
            time = 0.0
            timeSlider.value = 0.0
        }
    }
    
    @objc func updateSlider(_ timer: Timer) {
        if AudioBackend.sharedInstance.isPlaying {
            timeSlider.value += 0.1
        }
    }
    
    @IBAction func changedTime(_ slider: UISlider) {
        pause()
        time = TimeInterval(slider.value)
    }
    
    func resetTimer() {
        if time < 0 || time > AudioBackend.sharedInstance.getTotalDuration() {
            if time > AudioBackend.sharedInstance.getTotalDuration() {
                pause()
            }
            time = 0.0
            timeSlider.value = 0.0
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pause()
    }
}
