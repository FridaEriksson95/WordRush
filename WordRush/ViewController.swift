//
//  ViewController.swift
//  WordRush
//
//  Created by Frida Eriksson on 2025-03-24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var languageSelector: UISegmentedControl!
    var selectedLanguage: String = "english"
    @IBOutlet weak var textLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.layer.cornerRadius = 16
        textLabel.layer.masksToBounds = true
        textLabel.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textLabel.textContainer.lineFragmentPadding = 0
        
        languageSelector.selectedSegmentIndex = 0
    }
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        selectedLanguage = sender.selectedSegmentIndex == 0 ? "english" : "swedish"
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        selectedLanguage = languageSelector.selectedSegmentIndex == 0 ? "english" : "swedish"
        
        AnimalManager.shared.resetGame()
        
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        
        gameVC.selectedLanguage = selectedLanguage
        gameVC.modalPresentationStyle = .fullScreen
        
        if presentedViewController != nil {
            dismiss(animated: false, completion: {
                self.present(gameVC, animated: true, completion: nil)
            })
        } else {
            present(gameVC, animated: true, completion: nil)
        }
    }
}
