//
//  AddViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var buttonBorderView: UIView! {
        didSet {
            buttonBorderView.layer.borderWidth = 3
            buttonBorderView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1.0)
            buttonBorderView.layer.cornerRadius = 75
        }
    }
    @IBOutlet weak var recordButton: UIButton!

    var isRecording: Bool = false
    var start: CFAbsoluteTime!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func record(_ sender: Any) {
        if AudioBackend.sharedInstance.isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func startRecording() {
        recordButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
        start = CFAbsoluteTimeGetCurrent()
        let newIdentifier = Int(start)
        AudioBackend.sharedInstance.startRecording(with: "\(newIdentifier)", from: self)
    }

    func stopRecording() {
        guard let start = start else { return }
        recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        let end = CFAbsoluteTimeGetCurrent() - start
        AudioBackend.sharedInstance.stopRecording()
        showAlert(end)
    }

    func showAlert(_ length: CFAbsoluteTime) {
        let alert = UIAlertController(title: "Novo áudio", message: "Você quer adicionar um novo áudio?", preferredStyle: .alert)
        
        let newIdentifier = Int(self.start)

        let actionAdd = UIAlertAction(title: "Salvar", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                let date = Date()
                let calendar = Calendar.current

                let day = calendar.component(.day, from: date)
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                
                let audio = Audio(title: text,
                                 length: String(format: "%02d:%02d", Int(length / 60), Int(length.truncatingRemainder(dividingBy: 60))),
                                   time: String(format: "%02d:%02d", hour, minutes),
                                   date: "\(day)/\(month)/\(year)",
                                   identifier: "\(newIdentifier)")
                AudioBackend.sharedInstance.addToArrayOfAudios(audio: audio)
                self.navigationController!.popViewController(animated: true)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: .destructive) { _ in
            AudioBackend.sharedInstance.deleteRecording(with: "\(newIdentifier)")
        }

        alert.addAction(actionAdd)
        alert.addAction(actionCancel)

        alert.addTextField()

        present(alert, animated: true, completion: nil)
    }
}
