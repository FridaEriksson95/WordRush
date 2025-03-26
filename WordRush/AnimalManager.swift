//
//  AnimalManager.swift
//  WordRush
//
//  Created by Frida Eriksson on 2025-03-25.
//

import Foundation

class AnimalManager {
    static let shared = AnimalManager()
    private let animals: [(swedish: String, english: String)] = [
        ("Lejon 🦁", "Lion"),
        ("Tiger 🐅", "Tiger"),
        ("Elefant 🐘", "Elephant"),
        ("Giraff 🦒", "Giraffe"),
        ("Zebra 🦓", "Zebra"),
        ("Känguru 🦘", "Kangaroo"),
        ("Panda 🐼", "Panda"),
        ("Isbjörn 🐻‍❄️", "Polar Bear"),
        ("Varg 🐺", "Wolf"),
        ("Räv 🦊", "Fox"),
        ("Ko 🐄", "Cow"),
        ("Häst 🐎", "Horse"),
        ("Gris 🐖", "Pig"),
        ("Får 🐑", "Sheep"),
        ("Get 🐐", "Goat"),
        ("Hund 🐕", "Dog"),
        ("Katt 🐈", "Cat"),
        ("Papegoja 🦜", "Parrot"),
        ("Uggla 🦉", "Owl"),
        ("Delfin 🐬", "Dolphin"),
        ("Haj 🦈", "Shark"),
        ("Bläckfisk 🐙", "Octopus"),
        ("Pingvin 🐧", "Penguin"),
        ("Krokodil 🐊", "Crocodile"),
        ("Sköldpadda 🐢", "Turtle"),
        ("Ekorre 🐿️", "Squirrel"),
        ("Igelkott 🦔", "Hedgehog"),
        ("Tvättbjörn 🦝", "Raccoon"),
        ("Myrslok 🐜", "Anteater"),
        ("Flodhäst 🦛", "Hippopotamus"),
        ("Bältdjur", "Armadillo")
    ]
    
    private var usedAnimals: [String] = []
      private var currentIndex = 0
      private var usedIndices = Set<Int>()
      private var score = 0
      
      func getRandomAnimal() -> (swedish: String, english: String)? {
          guard animals.count > 0 else { return nil }
          
          // Om alla djur har använts, börja om
          if usedIndices.count >= animals.count {
              usedIndices.removeAll()
          }
          
          // Hitta ett slumpat index som inte använts
          var randomIndex: Int
          repeat {
              randomIndex = Int.random(in: 0..<animals.count)
          } while usedIndices.contains(randomIndex)
          
          usedIndices.insert(randomIndex)
          return animals[randomIndex]
      }
      
      func checkCorrectAnswer(userInput: String, forSwedishWord: String) -> Bool {
          guard let animal = animals.first(where: { $0.swedish == forSwedishWord }) else {
              return false
          }
          return userInput.lowercased() == animal.english.lowercased()
      }
      
      func increaseScore(by points: Int) {
          score += points
      }
      
      func resetGame() {
          currentIndex = 0
          usedIndices.removeAll()
          score = 0
      }
      
      func getCurrentScore() -> Int {
          return score
      }
  }




