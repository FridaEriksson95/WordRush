import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {


   @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!

    @IBOutlet weak var EnterButton: UIButton!
    
    let animalManager = AnimalManager()
    var countDownTimer: Timer?
    var remainingTime = 8
    let shapeLayer = CAShapeLayer()
    var currentAnimal: (swedish: String, english: String)?
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        answerTextField.delegate = self
        answerTextField.returnKeyType = .done
        EnterButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStartAlert()
    }
    func setupUI() {
        guard let wordLabel = wordLabel,
              let answerTextField = answerTextField,
              let scoreLabel = scoreLabel,
              let timerLabel = timerLabel
        else { return
        }
        
        wordLabel.layer.cornerRadius = 20
        wordLabel.layer.masksToBounds = true
        scoreLabel.text = "Points: 0"
        timerLabel.isHidden = true
    }

    
    func showStartAlert() {
        let alert = UIAlertController(
            title: "Vill du starta spelet?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Starta", style: .default) { [weak self] _ in
            self?.startGame()
        })
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel) { [weak self] _ in
            self?.navigateBackToStart()
        })
        
        present(alert, animated: true) {
            alert.view.tintColor = .purple
        }
    }
    
    func setupCountDownCircle() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.size.width / 2, y: view.safeAreaInsets.top + 140),
            radius: 50,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1.0
        view.layer.addSublayer(shapeLayer)
    }
    
    func startGame() {
        if let animal = animalManager.getRandomAnimal() {
            wordLabel.text = animal.swedish
            currentAnimal = animal
        } else {
            wordLabel.text = "You succeded with all animals! Congratz!"
            navigateToHighScore()
            return
    
        }
        setupCountDownCircle()
        answerTextField.text = ""
        startCountDown()
    }
    
    func startCountDown() {

        timerLabel.isHidden = false
        timerLabel.text = "\(remainingTime)"
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = CFTimeInterval(remainingTime)
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "countdown")
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.remainingTime -= 1
            self.timerLabel.text = "\(self.remainingTime)"
            
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        countDownTimer?.invalidate()
        shapeLayer.removeAllAnimations()
        
        HighScoreManager.shared.addHighscore(score: score)
        
        let alert = UIAlertController(
            title: "Game Over!",
            message: "Din poäng: \(score)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Spela igen", style: .default) { [weak self] _ in
            self?.resetGame()
        })
        
        alert.addAction(UIAlertAction(title: "Highscores", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // Försök att hämta ViewController från Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let highscoreVC = storyboard.instantiateViewController(withIdentifier: "HighscoreViewController") as? HighscoreViewController {
                self.present(highscoreVC, animated: true)
            } else {
                print("Kunde inte hitta HighscoreViewController")
            }
        })
        
        present(alert, animated: true) {
            alert.view.tintColor = .purple
        }
    }

    func resetGame() {
        score = 0
        scoreLabel.text = "Points: 0"
        remainingTime = 8
        startGame()
        resetTimer()
    }
    
    func resetTimer() {
        countDownTimer?.invalidate()
        shapeLayer.removeAllAnimations()
        remainingTime = 8
    }
    
    func navigateBackToStart() {
        dismiss(animated: true, completion: nil)
    }
    func navigateToHighScore() {
        performSegue(withIdentifier: "toHighScore", sender: self)
    }
    @objc func checkAnswer() {
            guard let userInput = answerTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !userInput.isEmpty,
                  let currentAnimal = currentAnimal else {
                return
            }
            
            if animalManager.checkCorrectAnswer(userInput: userInput, forSwedishWord: currentAnimal.swedish) {
                // Rätt svar
                score += 10
                scoreLabel?.text = "Points: \(score)"
                showCorrectAnswerAnimation()
                countDownTimer?.invalidate()
                shapeLayer.removeAllAnimations()
                remainingTime = 8
                startGame()
            } else {
                // Fel svar
                score = max(0, score - 5) // Förhindra negativ poäng
                scoreLabel?.text = "Points: \(score)"
                showWrongAnswerAnimation()
                answerTextField?.text = ""
            }
        }
        
        // MARK: - UITextFieldDelegate
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let userInput = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !userInput.isEmpty,
                  let currentAnimal = currentAnimal else {
                return false
            }
            
            if animalManager.checkCorrectAnswer(userInput: userInput, forSwedishWord: currentAnimal.swedish) {
                // Rätt svar
                score += 10
                scoreLabel?.text = "Points: \(score)"
                showCorrectAnswerAnimation()
                countDownTimer?.invalidate()
                shapeLayer.removeAllAnimations()
                remainingTime = 8
                startGame()
            } else {
                // Fel svar
                score = max(0, score - 5) // Förhindra negativ poäng
                scoreLabel?.text = "Points: \(score)"
                showWrongAnswerAnimation()
                textField.text = ""
            }
            
            textField.resignFirstResponder()
            return true
        }
        
        // MARK: - Animations
        private func showCorrectAnswerAnimation() {
            UIView.animate(withDuration: 0.3, animations: {
                self.wordLabel?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.wordLabel?.textColor = .systemGreen
            }) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.wordLabel?.transform = .identity
                    self.wordLabel?.textColor = .label
                }
            }
        }
        
        private func showWrongAnswerAnimation() {
            UIView.animate(withDuration: 0.1, animations: {
                self.answerTextField?.transform = CGAffineTransform(translationX: 10, y: 0)
                self.answerTextField?.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.answerTextField?.transform = CGAffineTransform(translationX: -10, y: 0)
                }) { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.answerTextField?.transform = .identity
                        self.answerTextField?.backgroundColor = .clear
                    }
                }
            }
        }
    }
    
