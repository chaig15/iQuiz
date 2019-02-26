//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Chai Gangavarapu on 2/21/19.
//  Copyright © 2019 Chaitanya Gangavarapu. All rights reserved.
//

import UIKit


class QuestionViewController: UIViewController {
    
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    var questions: [Question] = [];
    var current: Int = 0;
    var selected: [Int] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enterButton.isEnabled = false;
        Question.text = questions[current].text
        answer1.setTitle(questions[current].answers[0], for: .normal);
        answer2.setTitle(questions[current].answers[1], for: .normal);
        answer3.setTitle(questions[current].answers[2], for: .normal);
        answer4.setTitle(questions[current].answers[3], for: .normal);
    }
    
    func disableButtons () {
        answer1.isEnabled = false;
        answer2.isEnabled = false;
        answer3.isEnabled = false;
        answer4.isEnabled = false;
    }
    
    @IBAction func pickAnswer(_ sender: UIButton) {
        let tag: Int = sender.tag;
        if (tag == 1) {
            answer1.isSelected = true;
        } else if (tag == 2) {
            answer2.isSelected = true;
        } else if (tag == 3) {
            answer3.isSelected = true;
        } else if (tag == 4) {
            answer4.isSelected = true;
        }
        disableButtons();
        enterButton.isEnabled = true;
        selected.append(tag);
    }
    
    
    
    @IBAction func submitButton(_ sender: UIButton) {
    self.performSegue(withIdentifier: "answerSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let answerViewController = segue.destination as! AnswerViewController
        answerViewController.allAnswers = self.selected;
        answerViewController.questions = self.questions;
        answerViewController.current = self.current
        
    }
    
}
