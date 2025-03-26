// HighscoreCell.swift
import UIKit

class HighscoreCell: UITableViewCell {
    // 1. Skapa dina egna labels
    let rankLabel = UILabel()
    let scoreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        // 2. Konfigurera labels
        rankLabel.textAlignment = .left
        scoreLabel.textAlignment = .center
        
        // 3. Lägg till i contentView
        contentView.addSubview(rankLabel)
        contentView.addSubview(scoreLabel)
        
        // 4. Ställ in Auto Layout constraints
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Rank label (vänster)
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),
            
            // Score label (mitten)
            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
