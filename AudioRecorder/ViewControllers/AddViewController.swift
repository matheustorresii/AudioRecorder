//
//  AddViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 11/10/20.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var buttonBorderView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    var isRecording: Bool = false
    
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
        } else {
            recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
    }
    
}
