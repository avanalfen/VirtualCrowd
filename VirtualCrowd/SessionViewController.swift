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
    
    @IBOutlet var viewOfSpencer: UIVisualEffectView!
    @IBOutlet var visualEffectAddQuestionView: UIVisualEffectView!
    @IBOutlet var addQuestionView: UIView!
    @IBOutlet weak var addQuestionTextField: UITextField!
    @IBOutlet weak var sessionQuestionsTableView: UITableView!
    @IBOutlet weak var sessionCodeLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = SessionController.sharedController.sessions.filter({ $0.identifier == self.session?.identifier })[0]
        self.title = session.title
        sessionCodeLabel.text = "Code: \(session.code)"
        sessionTimerLabel.text = "\(session.timeLimit)"
        sessionQuestionsTableView.estimatedRowHeight = 100
        sessionQuestionsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: sessionQuestionsTableView.frame.width, height: 20)
        sessionCodeLabel.backgroundColor = UIColor(displayP3Red: 247, green: 248, blue: 192, alpha: 1)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector((longPress)))
        longTap.numberOfTapsRequired = 1
        longTap.minimumPressDuration = 5
        view.addGestureRecognizer(longTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sessionQuestionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let session = SessionController.sharedController.sessions.filter({ $0.identifier == self.session?.identifier })[0]
        return session.questions.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        let session = SessionController.sharedController.sessions.filter({ $0.identifier == self.session?.identifier })[0]
        let indexOfQustion = indexPath.section + indexPath.row
        let question = session.questions[indexOfQustion]
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.questionTextLabel.text = question.statement
        cell.upVoteButton.setTitle("\(question.upVotes)", for: .normal)
        
        if question.votedOn == true {
            cell.layer.borderColor = UIColor.green.cgColor
        } else {
            cell.layer.borderColor = UIColor.black.cgColor
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
        let session = SessionController.sharedController.sessions.filter({ $0.identifier == self.session?.identifier })[0]
        SessionController.sharedController.addQuestionToSession(statement: text, session: session)
        addQuestionTextField.text = ""
        visualEffectAddQuestionView.removeFromSuperview()
        sessionQuestionsTableView.reloadData()
    }
    
    @IBAction func upVoteButtonPressed(_ sender: UIButton) {
        guard let session = self.session else { return }
        guard let index = sessionQuestionsTableView.indexPathForRowContaining(view: sender) else { return }
        let question = session.questions[index.section - index.row]
            SessionController.sharedController.addVoteToQuestion(question: question)
            sessionQuestionsTableView.reloadData()
    }
    
    func longPress() {
        view.addSubview(viewOfSpencer)
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
