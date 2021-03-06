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
        self.getJSON(url: self.currentURL, isOnline: { (online) in
            if (online == false) {
                DispatchQueue.main.async {
                    let quizData = UserDefaults.standard.data(forKey: "quiz")
                    if (quizData != nil) {
                        let quizObject = try! JSONDecoder().decode([QuizInfo].self, from: quizData!);
                        self.quizzes = quizObject;
                        self.TopicTableView.reloadData();
                        print("local");
                    }
                }
            }
        });
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
    
    func getJSON(url: URL,  isOnline: @escaping (_ online: Bool) -> ()) {
        var online: Bool = true;
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                online = false;
                let alertController = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert);
                alertController.addAction(UIAlertAction(title: "OK", style: .default));
                self.present(alertController, animated: true, completion: nil);
                isOnline(online);
            }
            //Get back to the main queue
            guard let data = data else { return }
            do {
                let quizData = try JSONDecoder().decode([QuizInfo].self, from: data)
                DispatchQueue.main.async {
                    self.quizzes = quizData;
                    self.TopicTableView.reloadData();
                    let quizData = try! JSONEncoder().encode(quizData);
                    UserDefaults.standard.set(quizData, forKey: "quiz");
                    print("online download");
                    isOnline(online);
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
        let alert = UIAlertController(title: "JSON URL", message: "Enter a URL", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.currentURL.absoluteString;
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            let url = URL(string: textField.text ?? self.currentURL.absoluteString) ;
            self.getJSON(url: url!, isOnline: { (online) in
            });
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}

