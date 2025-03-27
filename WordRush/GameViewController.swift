import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {


   @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    
    let animalManager = AnimalManager()
    var countDownTimer: Timer?
    let shapeLayer = CAShapeLayer()
    var currentAnimal: (swedish: String, english: String)?
    private var previousLevel = 1
    
    var remainingTime: Int {
        let baseTime = 8
        let currentLevel = animalManager.getCurrentLevel()
        let calculatedTime = max(baseTime - (currentLevel - 1) * 2, 3)
        return calculatedTime
    }
    
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
              let scoreLabel = scoreLabel,
              let timerLabel = timerLabel,
              let levelLabel = levelLabel
        else { return }
        
        wordLabel.layer.cornerRadius = 20
        wordLabel.layer.masksToBounds = true
        scoreLabel.text = "Points: 0"
        levelLabel.text = "Level: \(animalManager.getCurrentLevel())"
        timerLabel.isHidden = true
        previousLevel = animalManager.getCurrentLevel()
    }

    
    func showStartAlert() {
        let alert = UIAlertController(
            title: "Would you like to start?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Start", style: .default) { [weak self] _ in
            self?.startGame()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
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
        startCountDown()
        answerTextField.text = ""
        updateScoreAndLevel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.answerTextField.becomeFirstResponder()
        }
    }
    
    func startCountDown() {
        timerLabel.isHidden = false
        var timeLeft = remainingTime
        timerLabel.text = "\(timeLeft)"
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = CFTimeInterval(remainingTime)
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "countdown")
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            timeLeft -= 1
            self.timerLabel.text = "\(timeLeft)"
            
            if timeLeft <= 0 {
                timer.invalidate()
                HighScoreManager.shared.addHighscore(score: animalManager.getCurrentScore())
                self.navigateToHighScore()
            }
        }
    }

    func resetGame() {
        animalManager.resetGame()
        startGame()
        resetTimer()
        previousLevel = 1
    }
    
    func resetTimer() {
        countDownTimer?.invalidate()
        shapeLayer.removeAllAnimations()
    }
    
    func navigateBackToStart() {
        dismiss(animated: true, completion: nil)
    }
    func navigateToHighScore() {
        performSegue(withIdentifier: "toHighScore", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHighScore",
           let highScoreVC = segue.destination as? HighscoreViewController {
            highScoreVC.getCurrentScore = animalManager.getCurrentScore()
        }
    }
    
    @objc func checkAnswer() {
            guard let userInput = answerTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !userInput.isEmpty,
                  let currentAnimal = currentAnimal else {
                return
            }
            
            if animalManager.checkCorrectAnswer(userInput: userInput, forSwedishWord: currentAnimal.swedish) {
                
                animalManager.increaseScore(by: 10)
                showCorrectAnswerAnimation()
                countDownTimer?.invalidate()
                shapeLayer.removeAllAnimations()
                resetTimer()
                startGame()
            } else {
                animalManager.increaseScore(by: -5)
                showWrongAnswerAnimation()
                answerTextField?.text = ""
                updateScoreAndLevel()
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            checkAnswer()
            textField.resignFirstResponder()
            return true
        }
    
    func updateScoreAndLevel() {
        scoreLabel?.text = "Points: \(animalManager.getCurrentScore())"
        let currentLevel = animalManager.getCurrentLevel()
        levelLabel?.text = "Level: \(currentLevel)"
        
        if currentLevel > previousLevel {
            showLevelUpAnimation()
            previousLevel = currentLevel
        }
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
            UIView.animate(withDuration: 0.3, animations: {
                self.wordLabel?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.wordLabel?.textColor = .systemRed
            }) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.wordLabel?.transform = .identity
                    self.wordLabel?.textColor = .label
                    }
                }
            }
    
        private func showLevelUpAnimation() {
            levelLabel?.alpha = 0
            levelLabel?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
            UIView.animate(withDuration: 0.5, animations: {
                self.levelLabel?.alpha = 1
                self.levelLabel?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.levelLabel?.textColor = .systemPink
                }) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.levelLabel?.transform = .identity
                    self.levelLabel?.textColor = .white
            }
        }
    }
}
