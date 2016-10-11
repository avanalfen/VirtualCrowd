//
//  SessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    var session: Session?
    var addQuestionViewIsShowing = false
    
    // MARK: Outlets
    
    @IBOutlet var visualEffectAddQuestionView: UIVisualEffectView!
    @IBOutlet var addQuestionView: UIView!
    @IBOutlet weak var addQuestionTextField: UITextField!
    @IBOutlet weak var sessionQuestionsTableView: UITableView!
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = session?.title
        sessionQuestionsTableView.estimatedRowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sessionQuestionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let session = self.session else { return 0 }
        return session.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        guard let session = self.session else { return QuestionTableViewCell() }
        let question = session.questions[indexPath.row]
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        
        cell.questionTextLabel.text = question.statement
        cell.upVoteButton.setTitle("\(question.upVotes)", for: .normal)
        
        if question.votedOn == true {
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    // MARK: Functions
    
    @IBAction func addQuestionButtonTapped(_ sender: UIBarButtonItem) {
        self.view.addSubview(self.visualEffectAddQuestionView)
        visualEffectAddQuestionView.center = view.center
    }
    
    @IBAction func nevermindButtonPressed(_ sender: UIButton) {
        visualEffectAddQuestionView.removeFromSuperview()
    }
    
    @IBAction func addQuestionSubmitButtonTapped(_ sender: UIButton) {
        guard let text = addQuestionTextField.text else { return }
        let question = Question(statement: text, session: self.session)
        session?.questions.append(question)
        addQuestionTextField.text = ""
        visualEffectAddQuestionView.removeFromSuperview()
        sessionQuestionsTableView.reloadData()
    }
    
    @IBAction func upVoteButtonPressed(_ sender: UIButton) {
        guard let session = self.session else { return }
        guard let index = sessionQuestionsTableView.indexPathForRowContaining(view: sender) else { return }
        let question = session.questions[index.row]
            SessionController.sharedController.addVoteToQuestion(question: question)
            sessionQuestionsTableView.reloadData()
    }
}

extension UITableView {
    func indexPathForRowContaining(view:UIView) -> IndexPath? {
        if view.superview == nil {
            return nil
        }
        let point = self.convert(view.center, from: view.superview)
        return self.indexPathForRow(at: point)
    }
}
