//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 10/10/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBSegueAction func navigateToAddViewController(_ coder: NSCoder) -> AddViewController? {
        let addViewController = AddViewController(coder: coder)
        return addViewController
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AudioBackend.sharedInstance.arrayOfAudios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell") as? AudioCell else { fatalError("Couldn't create cell") }
        
        cell.titleLabel.text = AudioBackend.sharedInstance.arrayOfAudios[indexPath.row].title
        cell.lengthLabel.text = AudioBackend.sharedInstance.arrayOfAudios[indexPath.row].length
        cell.timeLabel.text = AudioBackend.sharedInstance.arrayOfAudios[indexPath.row].time
        cell.dateLabel.text = AudioBackend.sharedInstance.arrayOfAudios[indexPath.row].date

        cell.parentController = self
        cell.audio = AudioBackend.sharedInstance.arrayOfAudios[indexPath.row]

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AudioBackend.sharedInstance.removeFromArrayOfAudios(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
