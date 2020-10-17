//
//  AudioBackend.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 12/10/20.
//

import UIKit
import AVFoundation

class AudioBackend {
    static let sharedInstance = AudioBackend()

    private(set) var arrayOfAudios: [Audio] = []
    
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var audioRecorder: AVAudioRecorder!

    private(set) var microphoneAllowed = false
    private(set) var isPlaying = false
    
    private let settings = [ AVFormatIDKey : kAudioFormatAppleLossless,
                  AVEncoderAudioQualityKey : AVAudioQuality.low.rawValue,
                       AVEncoderBitRateKey : 320000,
                     AVNumberOfChannelsKey : 2,
                           AVSampleRateKey : 44100.0 ] as [String : Any]

    private init() {
        initAudio()
        getFromUserDefaults()
    }

    private func initAudio() {
        audioSession.requestRecordPermission { allowed in if allowed { self.microphoneAllowed = allowed } }
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
        } catch {
            fatalError("Couldn't init audio")
        }
    }
    
    private func updateUserDefaults() {
        if let data = try? PropertyListEncoder().encode(arrayOfAudios) {
            UserDefaults.standard.set(data, forKey: "arrayOfAudios")
        }
    }
    
    func getFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "arrayOfAudios") {
            let newArray = try! PropertyListDecoder().decode([Audio].self, from: data)
            arrayOfAudios = newArray
        }
    }

    func addToArrayOfAudios(audio: Audio) {
        arrayOfAudios.append(audio)
        updateUserDefaults()
    }

    func removeFromArrayOfAudios(at indexPath: IndexPath) {
        arrayOfAudios.remove(at: indexPath.row)
        updateUserDefaults()
    }
    
    func setupAudio(with identifier: String, from viewController: AVAudioPlayerDelegate) {
        let audioFileName = getAudioPath(with: identifier)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = viewController
            audioPlayer.volume = 1.0
            try! audioSession.setActive(true)
        } catch {
            fatalError("Couldn't setup audio")
        }
    }
    
    func play(at time: TimeInterval) {
        audioPlayer.currentTime = time
        audioPlayer.play()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func stop() {
        pause()
        audioPlayer.stop()
    }
    
    func getAudioPlayerCurrentTime() -> TimeInterval {
        audioPlayer.currentTime
    }
    
    func getAudioPlayerTotalDuration() -> TimeInterval {
        audioPlayer.duration
    }

    func startRecording(with identifier: String, from viewController: AVAudioRecorderDelegate) {
        let audioFileName = getAudioPath(with: identifier)

        guard let recorder = try? AVAudioRecorder(url: audioFileName, settings: settings) else { fatalError("Couldn't init recorder") }
        
        audioRecorder = recorder
        audioRecorder.delegate = viewController
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        try! audioSession.setActive(true)
    }
    
    func deleteRecording(with identifier: String) {
        let audioFileName = getAudioPath(with: identifier)
        guard let recorder = try? AVAudioRecorder(url: audioFileName, settings: settings) else { fatalError("Couldn't init recorder") }
        try! FileManager.default.removeItem(atPath: recorder.url.path)
    }

    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        try! audioSession.setActive(false)
    }

    private func getAudioPath(with identifier: String) -> URL {
        let dirPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let audioURL = dirPath.appendingPathComponent("\(identifier).m4a")
        print(audioURL)
        return audioURL
    }
}
