//
//  ViewController.swift
//  WordRush
//
//  Created by Frida Eriksson on 2025-03-24.
//

import UIKit

class ViewController: UIViewController {
  

  @IBOutlet weak var textLabel: UITextView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    textLabel.layer.cornerRadius = 16
    textLabel.layer.masksToBounds = true
    textLabel.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    textLabel.textContainer.lineFragmentPadding = 0
    }


}

