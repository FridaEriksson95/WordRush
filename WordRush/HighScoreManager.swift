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
    private let highScoresKey = "HighScores"
    
    private init() {
        loadHighScores()
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
        
        if highscores.count > 10 {
            highscores = Array(highscores.prefix(10))
        }
        
        // Uppdatera placeringar
        for (index, _) in highscores.enumerated() {
            highscores[index] = HighScoreEntry(
                score: highscores[index].score,
                rank: index + 1
            )
        }
        saveHighScores()
    }
    
    func removeHighScore(at index: Int) {
        guard index >= 0 && index < highscores.count else { return }
        highscores.remove(at: index)
        
        for(index, _) in highscores.enumerated() {
            highscores[index] = HighScoreEntry(
                score: highscores[index].score, rank: index + 1)
        }
        saveHighScores()
    }
    
    func saveHighScores() {
        if let encoded = try? JSONEncoder().encode(highscores) {
            UserDefaults.standard.set(encoded, forKey: highScoresKey)
        }
    }
    
    private func loadHighScores() {
        if let savedData = UserDefaults.standard.data(forKey: highScoresKey),
            let loadedHighscores = try? JSONDecoder().decode([HighScoreEntry].self, from: savedData) {
            highscores = loadedHighscores
        }
    }
}
