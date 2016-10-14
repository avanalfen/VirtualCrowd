//
//  SessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: Properties
    //----------------------------------------------------------------------------------------------------------------------
    
    var session: Session?
    var selectedRowIndex = -1
    var selectedCellIndex = -1
    var thereIsCellTapped = false
    var cellIsExpanded: Bool = false
    var addQuestionViewIsShowing = false
    var notesVisible: Bool = false
    var selectedIndexPath: IndexPath? = nil
    var previousCellIndexPath: IndexPath?
    let formatter = DateFormatter()
    
    // MARK: Outlets
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet var addQuestionView: UIView!
    @IBOutlet weak var sessionCodeLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    @IBOutlet var viewOfSpencer: UIVisualEffectView!
    @IBOutlet weak var addQuestionTextField: UITextField!
    @IBOutlet weak var sessionQuestionsTableView: UITableView!
    @IBOutlet var visualEffectAddQuestionView: UIVisualEffectView!
    
    // MARK: View Setup
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSessionLabels()
        setupTapGesture()
        
        if self.session?.isActive == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: TableView
    //----------------------------------------------------------------------------------------------------------------------
// .
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let previousCellIndexPath = previousCellIndexPath {
            guard let cell = tableView.cellForRow(at: previousCellIndexPath) as? QuestionTableViewCell else { return }
            cell.notesLabel.isHidden = true
            cell.notesTextField.isHidden = true
        }
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath! == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.sessionQuestionsTableView.beginUpdates()
        self.sessionQuestionsTableView.endUpdates()
        
        previousCellIndexPath = indexPath
       
    }
// .
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let justQuestionHeight: CGFloat = 60.0
        let questionAndNotesHeight: CGFloat = 190.0
        let ip = indexPath
        if selectedIndexPath != nil {
            if ip == selectedIndexPath {
                return questionAndNotesHeight
            } else {
                return justQuestionHeight
            }
        } else {
            return justQuestionHeight
        }
        
    }
    
// .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        guard let session = self.session else { return QuestionTableViewCell() }
        let indexOfQustion = indexPath.section + indexPath.row
        let question = session.questions[indexOfQustion]
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        
        if question.votedOn == true {
            cell.layer.borderColor = UIColor.green.cgColor
        } else {
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        if selectedIndexPath != nil {
            cell.notesLabel.isHidden = false
            cell.notesTextField.isHidden = false
        } else {
            cell.notesTextField.isHidden = true
            cell.notesLabel.isHidden = true
        }
        
        cell.questionTextLabel.text = question.statement
        cell.upVoteButton.setTitle("\(question.upVotes)", for: .normal)
//        cell.notesTextField.delegate = self
//        cell.notesTextField.text = question.notes
//        cell.notesTextField.resignFirstResponder()
        
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("It changed")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("It Ended")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("It began")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let session = self.session else { return 0 }
        return session.questions.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: Functions
    //----------------------------------------------------------------------------------------------------------------------
    
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
    
    func setupSessionLabels() {
        guard let session = self.session else { return }
        self.title = session.title
        let endTime = date(date: session.endDate).timeR
        self.sessionCodeLabel.text = "Entry code: \(session.code)"
        self.sessionTimerLabel.text = "Ending time: \(endTime)"
        sessionQuestionsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: sessionQuestionsTableView.frame.width, height: 20)
        sessionCodeLabel.backgroundColor = UIColor(displayP3Red: 247, green: 248, blue: 192, alpha: 1)
        
        if self.session?.isActive == false {
            sessionQuestionsTableView.tableHeaderView?.isHidden = true
        }
    }
    
    func setupTapGesture() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector((longPress)))
        longTap.numberOfTapsRequired = 1
        longTap.minimumPressDuration = 5
        view.addGestureRecognizer(longTap)
    }
    
    func longPress() {
        view.addSubview(viewOfSpencer)
    }
    
    // MARK: Textfield Functions
    //----------------------------------------------------------------------------------------------------------------------
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        SessionController.sharedController.addNotesToQuestion(text: notes, question: <#T##Question#>)
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
