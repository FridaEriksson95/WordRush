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
        
        tableView.register(HighscoreCell.self, forCellReuseIdentifier: "highscoreCell")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "highscoreCell", for: indexPath) as! HighscoreCell
        
        let highscore = highscores[indexPath.row]
        
        cell.rankLabel.text = "\(highscore.rank)."
        cell.scoreLabel.text = "\(highscore.score) poäng"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
