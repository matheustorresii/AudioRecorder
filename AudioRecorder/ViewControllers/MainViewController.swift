//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 10/10/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfAudios: [Audio] = [
        Audio(title: "Roteiro trabalho de portugues", length: "05:14", time: "18:49", date: "27/09/2020"),
        Audio(title: "RPG", length: "4:12:55", time: "23:54", date: "28/10/2020")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfAudios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell") as? AudioCell else {
            fatalError("Couldn't create cell")
        }
        
        cell.titleLabel.text = arrayOfAudios[indexPath.row].title
        cell.lengthLabel.text = arrayOfAudios[indexPath.row].length
        cell.timeLabel.text = arrayOfAudios[indexPath.row].time
        cell.dateLabel.text = arrayOfAudios[indexPath.row].date
        
        cell.parentController = self
        cell.audio = arrayOfAudios[indexPath.row]
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfAudios.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
