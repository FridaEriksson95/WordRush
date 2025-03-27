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

    @IBOutlet weak var RankLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hämta highscores från HighscoreManager
        highscores = HighScoreManager.shared.getAllHighscores()
      
        // Sortera (högsta först)
        highscores.sort { $0.score > $1.score }
      
        // Tilldela emojis
      for (index, var entry) in highscores.enumerated() {
          if index == 0 {
              entry.emoji = "🏆"  // Högsta poäng
          } else if entry.score == getCurrentScore {
              entry.emoji = "🎯"  // Aktuell spelare
          } else {
              entry.emoji = nil  // Återställ
          }
          highscores[index] = entry  // Uppdatera listan med ändrat objekt
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
        
        let highscore = highscores[indexPath.row]
      
      // TextFormat
        let displayText = "\(highscore.rank).".padding(toLength: 30, withPad: " ", startingAt: 0) +
                          "\(highscore.score) poäng".padding(toLength: 30, withPad: " ", startingAt: 0) +
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
        return 50
    }
}
