//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Chai Gangavarapu on 2/21/19.
//  Copyright © 2019 Chaitanya Gangavarapu. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var responseText: UILabel!
    
    var questions: [Question] = [];
    var current: Int = 0;
    var allAnswers: [Int] = [];
    var correctAnswers: [Int] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let answer: Int = Int(self.questions[current].answer)!;
        self.questionText.text = self.questions[current].text;
        self.answerText.text = self.questions[current].answers[answer-1];
        if (answer == self.allAnswers[current]) {
            self.responseText.text = "Correct!";
        } else {
            self.responseText.text = "Wrong!";
        }
        for question in self.questions {
            correctAnswers.append(Int(question.answer) ?? 0);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if going to a next question, increment the currentQuestion
        if (segue.identifier == "questionNextSegue") {
            let questionViewController = segue.destination as! QuestionViewController
            questionViewController.current = self.current + 1
            questionViewController.questions = self.questions
            questionViewController.selected = self.allAnswers;
        }
        if (segue.identifier == "finishSegue") {
            let finishViewController = segue.destination as! FinishedViewController;
            finishViewController.numQuestions = self.questions.count;
            var numCorrect: Int = 0;
            for (index, element) in self.correctAnswers.enumerated() {
                if (self.correctAnswers[index] == self.allAnswers[index]) {
                    numCorrect += 1;
                }
            }
            finishViewController.correctAnswers = numCorrect;
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        print(current);
        print(self.questions.count);
        if (current + 1 < self.questions.count) {
            self.performSegue(withIdentifier: "questionNextSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "finishSegue", sender: self)
        }
    }
}

