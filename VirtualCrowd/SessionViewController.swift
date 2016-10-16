//
//  SessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate, QuestionUpvoteDelegate {
    
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
    var lastNoteTaken: String = ""
    var lastQuestionViewed: Question? = nil
    
    // MARK: Outlets
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private var addQuestionView: UIView!
    @IBOutlet weak private var sessionTimerLabel: UILabel!
    @IBOutlet private var viewOfSpencer: UIVisualEffectView!
    @IBOutlet weak private var addQuestionTextField: UITextField!
    @IBOutlet weak private var sessionQuestionsTableView: UITableView!
    @IBOutlet private var visualEffectAddQuestionView: UIVisualEffectView!
    
    // MARK: View Setup
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSessionMisc()
        setupTapGesture()
        setupAddButton()
        setupBackButton()
        setupInfoButton()
        
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
            cell.notesTextField.resignFirstResponder()
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
        
        let justQuestionHeight: CGFloat = 60
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
        let ip = indexPath
        let indexOfQustion = indexPath.section + indexPath.row
        let question = session.sortedQuestion[indexOfQustion]
        
        cell.delegate = self
        cell.updateWith(question: question)
        cell.question = question
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        
        if question.votedOn == true {
            cell.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        if selectedIndexPath == ip {
            cell.notesLabel.isHidden = false
            cell.notesTextField.isHidden = false
        } else {
            cell.notesTextField.isHidden = true
            cell.notesLabel.isHidden = true
        }
        
        cell.notesTextField.delegate = self
        cell.notesTextField.resignFirstResponder()
        
        return cell
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.session?.questions[(previousCellIndexPath?.section)! + (previousCellIndexPath?.row)!].notes = textView.text
        print("It Ended")
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
    
    func upVotePressed(cell: QuestionTableViewCell) {
        guard let question = cell.question else { return }
        SessionController.sharedController.addVoteToQuestion(question: question)
        cell.updateWith(question: question)
        sessionQuestionsTableView.reloadData()
    }
    
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupSessionMisc() {
        // Labels
        guard let session = self.session else { return }
        self.title = session.title
        let endTime = date(date: session.endDate).timeR
        self.titleLabel.text = session.title
        self.titleLabel.tintColor = UIColor.white
        self.sessionTimerLabel.text = "Crowd ID: \(session.code)   Questions End: \(endTime)"
        sessionQuestionsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: sessionQuestionsTableView.frame.width, height: 20)
        
        // tableView
        sessionQuestionsTableView.tableHeaderView?.backgroundColor = UIColor.white
        self.sessionQuestionsTableView.tableFooterView = UIView()
        
        if self.session?.isActive == false {
            sessionQuestionsTableView.tableHeaderView?.isHidden = true
        }
    }
    
    func setupAddButton() {
        guard let session = self.session else { return }
        if session.isActive {
            let view = UIButton()
            view.layer.frame = CGRect(x: 300, y: 525, width: 60, height: 60)
            view.layer.cornerRadius = 0.5 * view.bounds.size.width
            view.clipsToBounds = true
            view.layer.backgroundColor = UIColor.blue.cgColor
            view.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            view.setTitle("+", for: .normal)
            view.tintColor = UIColor.white
            view.addTarget(self, action: #selector(addQuestionButtonTapped), for: .touchUpInside)
            self.view.addSubview(view)
            self.view.bringSubview(toFront: view)
        }
    }
    
    func setupBackButton() {
        let back = UIButton()
        back.layer.frame = CGRect(x: 15, y: 35, width: 40, height: 20)
        back.clipsToBounds = true
        back.setTitle("Back", for: .normal)
        back.setTitleColor(UIColor.blue, for: .normal)
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(back)
        view.bringSubview(toFront: back)
    }
    
    func setupInfoButton() {
        let info = UIButton()
        info.layer.frame = CGRect(x: 325, y: 35, width: 40, height: 20)
        info.clipsToBounds = true
        info.setTitleColor(UIColor.blue, for: .normal)
        info.setTitle("Info", for: .normal)
        view.addSubview(info)
        view.bringSubview(toFront: info)
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
