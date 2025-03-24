//
//  HighScoreManager.swift
//  WordRush
//
//  Created by Angelica E on 2025-03-24.
//

import Foundation

class HighScoreManager {
    static let shared = HighScoreManager()
    private var highscores: [HighScoreEntry] = []
    
    private init() {
        // Lägg till några test-highscores
        generateTestData()
    }
    //TEST UTSKRIFT
    private func generateTestData() {
        highscores = [
            HighScoreEntry(score: 250, rank: 1),
            HighScoreEntry(score: 200, rank: 2),
            HighScoreEntry(score: 180, rank: 3),
            HighScoreEntry(score: 150, rank: 4),
            HighScoreEntry(score: 120, rank: 5),
            HighScoreEntry(score: 100, rank: 6),
            HighScoreEntry(score: 90, rank: 7),
            HighScoreEntry(score: 80, rank: 8),
            HighScoreEntry(score: 70, rank: 9),
            HighScoreEntry(score: 60, rank: 10)
        ]
    }
    
    func getAllHighscores() -> [HighScoreEntry] {
        return highscores
    }
    
    func addHighscore(score: Int) {
        // Lägg till nytt highscore och sortera om listan
        let newEntry = HighScoreEntry(score: score, rank: 0)
        highscores.append(newEntry)
        
        // Sortera efter högst poäng
        highscores.sort { $0.score > $1.score }
        
        // Uppdatera placeringar
        for (index, _) in highscores.enumerated() {
            highscores[index] = HighScoreEntry(
                score: highscores[index].score,
                rank: index + 1
            )
        }
        
//        // Behåll bara top 10
//        if highscores.count > 10 {
//            highscores = Array(highscores.prefix(10))
//        }
    }
}
