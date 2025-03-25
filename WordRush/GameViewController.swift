//
//  GameViewController.swift
//  WordRush
//
//  Created by Frida Eriksson on 2025-03-24.
//

import UIKit

class GameViewController: UIViewController {


    @IBOutlet weak var TimesUpLabel: UILabel!
    @IBOutlet weak var WordLabel: UILabel!
    
    var countDownTimer: Timer?
    var remainingTime = 8
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        showStartAlert()

        WordLabel.layer.cornerRadius = 20
        WordLabel.layer.masksToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStartAlert()
    }
    
    func showStartAlert() {
        let alert = UIAlertController(
            title: "Vill du starta spelet?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Starta", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.setupCountDownCircle()
            self.startCountDown()
        })
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel) { [weak self] _ in
            guard let self = self else {return}
            self.navigateBackToStart()})
        
        present(alert, animated: true, completion: {
            alert.view.tintColor = .purple
        })
        
    }
    
    func setupCountDownCircle() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.size.width / 2, y: view.safeAreaInsets.top + 140),
            radius: 50,
            startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi / 2 * 3,
            clockwise: true
        )
        let tracklayer = CAShapeLayer()
        tracklayer.path = circlePath.cgPath
        tracklayer.strokeColor = UIColor.lightGray.cgColor
        tracklayer.lineWidth = 10
        tracklayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(tracklayer)
        
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1.0
        view.layer.addSublayer(shapeLayer)
    }
    

    func startCountDown(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 8
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "countdown")
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {return}
            
           self.remainingTime -= 1
            
            if self.remainingTime <= 0 {
                timer.invalidate()
                TimesUpLabel.isHidden = false
                resetTimer()
            }
        }
    }
    
    func navigateBackToStart() {
        dismiss(animated: true, completion: nil)
    }
    
    func resetTimer() {
        countDownTimer?.invalidate()
        shapeLayer.removeAllAnimations()
        remainingTime = 8
        showStartAlert()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
