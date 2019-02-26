//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Chai Gangavarapu on 2/25/19.
//  Copyright © 2019 Chaitanya Gangavarapu. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var correctAnswers: Int = 0;
    var numQuestions: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (correctAnswers == numQuestions) {
            self.overallLabel.text = "Perfect!"
        } else {
            self.overallLabel.text = "Try Again to get Perfect!"
        }
        
        self.scoreLabel.text = "\(correctAnswers)/\(numQuestions) correct!"
    }
    
    
}
