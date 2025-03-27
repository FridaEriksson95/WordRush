//
//  AnimalManager.swift
//  WordRush
//
//  Created by Frida Eriksson on 2025-03-25.
//

import Foundation

class AnimalManager {
    static let shared = AnimalManager()
    
    private let easyAnimals: [(swedish: String, english: String)] = [
        ("Lejon 🦁", "Lion"),
        ("Tiger 🐅", "Tiger"),
        ("Elefant 🐘", "Elephant"),
        ("Giraff 🦒", "Giraffe"),
        ("Zebra 🦓", "Zebra"),
        ("Panda 🐼", "Panda"),
        ("Varg 🐺", "Wolf"),
        ("Räv 🦊", "Fox"),
        ("Ko 🐄", "Cow"),
        ("Häst 🐎", "Horse"),
        ("Gris 🐖", "Pig"),
        ("Får 🐑", "Sheep"),
        ("Get 🐐", "Goat"),
        ("Hund 🐕", "Dog"),
        ("Katt 🐈", "Cat"),
        ("Uggla 🦉", "Owl"),
        ("Delfin 🐬", "Dolphin"),
        ("Haj 🦈", "Shark"),
        ("Kanin🐇", "Rabbit"),
        ("Spindel 🕷️", "Spider"),
        ("Björn 🐻", "Bear"),
        ("Hamster", "Hamster"),
        ("Svan 🦢", "Swan"),
        ("Anka 🦆", "Duck"),
        ]
    
    private let mediumAnimals: [(swedish: String, english: String)] = [
        ("Känguru 🦘", "Kangaroo"),
        ("Isbjörn 🐻‍❄️", "Polar Bear"),
        ("Papegoja 🦜", "Parrot"),
        ("Bläckfisk 🐙", "Octopus"),
        ("Pingvin 🐧", "Penguin"),
        ("Krokodil 🐊", "Crocodile"),
        ("Sköldpadda 🐢", "Turtle"),
        ("Orm", "Snake"),
        ("Groda 🐸", "Frog"),
        ("Salamander", "Salamander"),
        ("Myra 🐜", "Ant"),
        ("Fjäril 🦋", "Butterfly"),
        ("Örn 🦅", "Eagle"),
        ("Hök", "Hawk"),
        ("Kråka", "Crow"),
        ("Älg🦌", "Moose"),
        ("Ren", "Reindeer"),
        ("Rådjur", "Deer"),
        ("Utter", "Otter")
    ]
        
    private let hardAnimals: [(swedish: String, english: String)] = [
        ("Iller", "Ferret"),
        ("Vildsvin🐗", "Boar"),
        ("Mård", "Marten"),
        ("Tjäder", "Capercaillie"),
        ("Marsvin", "Guinea pig"),
        ("Järv", "Wolverine"),
        ("Skata", "Magpie"),
        ("Korp", "Raven"),
        ("Fiskmås", "Seagull"),
        ("Fasan", "Pheasant"),
        ("Huggorm 🐍", "Viper"),
        ("Tvättbjörn 🦝", "Raccoon"),
        ("Myrslok 🐜", "Anteater"),
        ("Flodhäst 🦛", "Hippopotamus"),
        ("Bältdjur", "Armadillo"),
        ("Nyckelpiga 🐞", "Ladybug"),
        ("Ekorre 🐿️", "Squirrel"),
        ("Igelkott 🦔", "Hedgehog")
    ]
    
      private var usedIndices: Set<Int> = []
      private var score = 0
      private var previousLevel = 1
      
      func getRandomAnimal() -> (swedish: String, english: String)? {
          let currentLevel = getCurrentLevel()
          let currentLevelAnimals: [(swedish: String, english: String)]
          
          if currentLevel != previousLevel{
              usedIndices.removeAll()
              previousLevel = currentLevel
          }
          
          switch score {
          case 0..<50:
              currentLevelAnimals = easyAnimals
          case 50..<100:
              currentLevelAnimals = mediumAnimals
          case 100...:
              currentLevelAnimals = hardAnimals
          default:
              currentLevelAnimals = easyAnimals
          }
          
          guard !currentLevelAnimals.isEmpty else {
              return nil
          }
          // Om alla djur har använts, börja om
          if usedIndices.count >= currentLevelAnimals.count {
              usedIndices.removeAll()
          }
          
          // Hitta ett slumpat index som inte använts
          var randomIndex: Int
          repeat {
              randomIndex = Int.random(in: 0..<currentLevelAnimals.count)
          } while usedIndices.contains(randomIndex)
          
          usedIndices.insert(randomIndex)
          return currentLevelAnimals[randomIndex]
      }
      
      func checkCorrectAnswer(userInput: String, forSwedishWord: String) -> Bool {
          let allAnimals = easyAnimals + mediumAnimals + hardAnimals
          guard let animal = allAnimals.first(where: { $0.swedish == forSwedishWord }) else {
              return false
          }
          return userInput.lowercased() == animal.english.lowercased()
      }
      
      func increaseScore(by points: Int) {
          score += points
      }
      
      func resetGame() {
          usedIndices.removeAll()
          score = 0
          previousLevel = 1
      }
      
      func getCurrentScore() -> Int {
          return score
      }
    
    func getCurrentLevel() -> Int {
        switch score {
        case 0..<50:
            return 1
        case 50..<100:
            return 2
        case 100...:
            return 3
        default:
            return 1
        }
    }
  }
