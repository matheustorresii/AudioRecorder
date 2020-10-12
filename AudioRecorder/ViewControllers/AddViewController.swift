//
//  AddViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController {
    
    var delegate: AddAudioDelegate?
    
    @IBOutlet weak var buttonBorderView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    var isRecording: Bool = false
    var start: CFAbsoluteTime? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        buttonBorderView.layer.cornerRadius = view.frame.width / 5.5
        buttonBorderView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        buttonBorderView.layer.borderWidth = 5
    }
    
    @IBAction func record(_ sender: Any) {
        isRecording = !isRecording
        if isRecording {
            recordButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
            start = CFAbsoluteTimeGetCurrent()
        } else {
            recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            guard let start = start else { return }
            let end = CFAbsoluteTimeGetCurrent() - start
            showAlert(end)
        }
    }
    
    func showAlert(_ length: CFAbsoluteTime) {
        let alert = UIAlertController(title: "Novo áudio", message: "Você quer adicionar um novo áudio?", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Salvar", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text, text != "" {
                let date = Date()
                let calendar = Calendar.current
                
                let day = calendar.component(.day, from: date)
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                
                let audio = Audio(title: text,
                                  length: String(format: "%02d:%02d", Int(length / 60), Int(length.truncatingRemainder(dividingBy: 60))),
                                   time: "\(hour):\(minutes)",
                                   date: "\(day)/\(month)/\(year)")
                
                self.delegate?.add(audio: audio)
                self.navigationController!.popViewController(animated: true)
            }
        }
        
        alert.addAction(actionAdd)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        alert.addTextField()
        
        present(alert, animated: true, completion: nil)
    }
}
