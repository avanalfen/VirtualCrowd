//
//  SessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

protocol textfieldChangedDelegate: class {
    func updateQuestionWith(text: String)
}

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate, UpVoteButtonPressedDelegate {
    
    // MARK: Properties
    //----------------------------------------------------------------------------------------------------------------------
    
    let session = SessionController.sharedController.activeSession
    var selectedIndexPath: IndexPath? = nil
    var previousCellIndexPath: IndexPath?
    var lastQuestionViewed: Question? = nil
    let cloudKitManager = CloudKitManager.sharedController
    var previousCellIndex: IndexPath?
    
    // MARK: Outlets
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet private var viewOfSpencer: UIVisualEffectView!
    @IBOutlet weak private var sessionQuestionsTableView: UITableView!
    
    // MARK: View Setup
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSessionLabels()
        setupTapGesture()
        SessionController.sharedController.fullSync()
        sessionQuestionsTableView.allowsSelection = false
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name(rawValue: "gotRecords"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SessionController.sharedController.viewIsBeingShownComingFromSession = true
        SessionController.sharedController.previousSession = self.session
    }
    
    // MARK: TableView
    //----------------------------------------------------------------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        let indexOfQuestion = indexPath.section + indexPath.row
        let question = SessionController.sharedController.questionsArray[indexOfQuestion]
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.upVoteDelegate = self
        cell.updateWith(question: question)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionController.sharedController.questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: Functions
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let session = SessionController.sharedController.activeSession else { return }
        let endTime = date(date: session.endDate).timeR
        let code = session.code
        let menu = UIAlertController(title: "Entry code:\(code) \n Ends at: \(endTime)", message: nil, preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .default, handler: nil)
        let question = UIAlertAction(title: "Submit Question", style: .default) { (_) in
            let alert = UIAlertController(title: "Enter A Question", message: nil, preferredStyle: .alert)
            var submitTextField: UITextField?
            alert.addTextField { (textField) in
                submitTextField = textField
            }
            let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
                guard let question = submitTextField?.text else { return }
                self.addQuestionSubmitButtonTapped(question: question)
                let alert2 = UIAlertController(title: "You've added a question!", message: "Your question should appear shortly", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert2.addAction(ok)
                self.present(alert2, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(submit)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        menu.addAction(question)
        menu.addAction(close)
        self.present(menu, animated: true, completion: nil)
    }
    
    func addQuestionSubmitButtonTapped(question: String) {
        guard let session = SessionController.sharedController.activeSession else { return }
        QuestionController.sharedController.createQuestionRecordFrom(statement: question, session: session)
        SessionController.sharedController.fullSync()
    }
    
    func addVoteToQuestion(question: Question) {
        let record = CKRecord(statement: question.statement, recordID: question.recordID!, votes: question.votes, session: SessionController.sharedController.activeSession!)
        cloudKitManager.modifyRecords([record], perRecordCompletion: { (record, error) in
            if let record = record {
                print(record)
            }
        }, completion: { (records, error) in
            if let records = records {
                print(records.count)
            }
        })
    }
 
    func setupSessionLabels() {
        guard let session = SessionController.sharedController.activeSession else { return }
        self.title = session.title
    }
    
    func reloadTable() {
        self.sessionQuestionsTableView.reloadData()
    }
    
    // MARK: Tap Gesture Easter Egg
    
    func setupTapGesture() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector((longPress)))
        longTap.numberOfTapsRequired = 1
        longTap.minimumPressDuration = 5
        view.addGestureRecognizer(longTap)
    }
    
    func longPress() {
        view.addSubview(viewOfSpencer)
    }
}

extension CKRecord {
    convenience init(statement: String, recordID: CKRecordID, votes: Int, session: Session) {
        let sessionID = session.recordID
        let question = Question(statement: statement, recordID: recordID, votes: votes, notes: "")
        let recordIDReference = CKReference(recordID: recordID, action: .none)
        let referenceToSession = CKReference(recordID: sessionID, action: .deleteSelf)
        
        self.init(recordType: Question.recordType, recordID: question.recordID!)
        self.setObject(question.statement as CKRecordValue?, forKey: Question.kStatement)
        self.setObject(recordIDReference, forKey: Question.kRecordID)
        self.setObject(referenceToSession, forKey: Question.kReference)
        self.setObject(question.votes as CKRecordValue?, forKey: Question.kVotes)
        self.setObject(question.notes as CKRecordValue?, forKey: Question.kNotes)
    }
}
