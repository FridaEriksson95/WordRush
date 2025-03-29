//
//  HighscoreTableViewController.swift
//  WordRush
//
//  Created by Angelica E on 2025-03-24.
//

import UIKit

class HighscoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var highscores: [HighScoreEntry] = []
    var getCurrentScore: Int = 0
    var latestPlayer: Int? = nil
    
    @IBOutlet weak var RankLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hämta highscores från HighscoreManager
        highscores = HighScoreManager.shared.getAllHighscores()
        
        // Sortera (högsta först)
        highscores.sort { $0.score > $1.score }
      
      // Hitta senaste den aktuella spelaren
      for index in stride(from: highscores.count - 1, through: 0, by: -1) {
          if highscores[index].score == getCurrentScore {
            latestPlayer = index
              break
          }
      }
        
      // Tilldela emojis
      for index in highscores.indices {
          if index == 0 {
              highscores[index].emoji = "🏆"  // Högsta poäng
          } else if let currentIndex = latestPlayer, index == currentIndex {
              highscores[index].emoji = "🎯"  // Endast senaste aktuella spelaren
          } else {
              highscores[index].emoji = nil  // Återställ
          }
      }
        
        // Sätt delegate och dataSource
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.layer.shadowRadius = 5
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highscoreCell", for: indexPath)
        cell.accessoryType = .none
        
        let highscore = highscores[indexPath.row]
        
        // TextFormat
        let displayText = "\(highscore.rank).".padding(toLength: 28, withPad: " ", startingAt: 0) +
        "\(highscore.score) points".padding(toLength: 28, withPad: " ", startingAt: 0) +
        (highscore.emoji ?? "")
        
        cell.textLabel?.text = displayText
        
        // MARKERA HÖGSTA POÄNGEN
        switch highscore.emoji {
        case "🏆":
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        case "🎯":
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        default:
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                presentDeleteAlert(for: indexPath)
            }
        }
    }
    
    func presentDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Would you like to delete this highscore?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteHighScore(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHighScore(at indexPath: IndexPath) {
        HighScoreManager.shared.removeHighScore(at: indexPath.row)
        highscores = HighScoreManager.shared.getAllHighscores()
        
        for (index, var entry) in highscores.enumerated() {
            if index == 0 {
            entry.emoji = "🏆"
        } else if entry.score == getCurrentScore {
            entry.emoji = "🎯"
        } else {
            entry.emoji = nil
        }
        highscores[index] = entry
    }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
