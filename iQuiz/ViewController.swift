//
//  ViewController.swift
//  iQuiz
//
//  Created by Chai Gangavarapu on 2/21/19.
//  Copyright © 2019 Chaitanya Gangavarapu. All rights reserved.
//

import UIKit


struct Question: Codable {
    var text: String;
    var answer: String;
    var answers: [String];
    
}

struct QuizInfo: Codable {
    var title: String;
    var desc: String;
    var questions: [Question];
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TopicTableView: UITableView!
    var currentURL: URL = URL(string: "https://tednewardsandbox.site44.com/questions.json")!
    var quizzes: [QuizInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getJSON(url: currentURL);
        TopicTableView.dataSource = self;
        TopicTableView.delegate = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizzes")!
        cell.textLabel?.text = quizzes[indexPath.row].title;
        cell.detailTextLabel?.text = quizzes[indexPath.row].desc;
        return cell;
    }
    
    func getJSON(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert);
                alertController.addAction(UIAlertAction(title: "OK", style: .default));
                self.present(alertController, animated: true, completion: nil);
            }
            //Get back to the main queue
            guard let data = data else { return }
            do {
                let quizData = try JSONDecoder().decode([QuizInfo].self, from: data)
                DispatchQueue.main.async {
                    self.quizzes = quizData;
                    self.TopicTableView.reloadData();
                }
                } catch let jsonError {
                    let alertController = UIAlertController(title: "Alert", message: jsonError.localizedDescription, preferredStyle: .alert);
                    alertController.addAction(UIAlertAction(title: "OK", style: .default));
                    self.present(alertController, animated: true, completion: nil);
                }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "questionSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let questionViewController = segue.destination as! QuestionViewController;
        questionViewController.questions = quizzes[TopicTableView.indexPathForSelectedRow!.item].questions
    }
    
    
    
    @IBAction func settingsClick(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Alert", message: "Settings go here", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default));
        self.present(alertController, animated: true, completion: nil);
    }
    

}

