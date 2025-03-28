//
//  HighScoreEntryModel.swift
//  WordRush
//
//  Created by Angelica E on 2025-03-24.
//

import Foundation

struct HighScoreEntry: Codable {
    let score: Int
    let rank: Int
    var emoji: String?
}
