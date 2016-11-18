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
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: View Setup
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
        setupSessionLabels()
        setupTapGesture()
        SessionController.sharedController.fullSync()
        tableView.allowsSelection = false
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name(rawValue: "QuestionArrayChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: TableView
    //----------------------------------------------------------------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        let indexOfQuestion = indexPath.section + indexPath.row
        let question = SessionController.sharedController.sortedQuestions[indexOfQuestion]
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.upVoteDelegate = self
        cell.updateWith(question: question)
        if SessionController.sharedController.questionsVotedOn.contains(question) {
            cell.upVoteButton.setBackgroundImage(#imageLiteral(resourceName: "thumbs-up-vector-art"), for: .normal)
        } else {
            cell.upVoteButton.setBackgroundImage(#imageLiteral(resourceName: "thumbs-up-vector-art copy"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionController.sharedController.sortedQuestions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: Functions
    //----------------------------------------------------------------------------------------------------------------------
    
    func infoTapped() {
        guard let session = SessionController.sharedController.activeSession else { return }
        let endTime = date(date: session.endDate).timeR
        let code = session.code
        let menu = UIAlertController(title: "Entry code: \(code) \n Ends at: \(endTime)", message: nil, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .default, handler: nil)
        menu.addAction(close)
        self.present(menu, animated: true, completion: nil)
    }
    
    func menuTapped() {
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
    
    func addQuestionSubmitButtonTapped(question: String) {
        guard let session = SessionController.sharedController.activeSession else { return }
        QuestionController.sharedController.createQuestionRecordFrom(statement: question, session: session)
    }
    
    func addVoteToQuestion(deviceQuestion: Question) {
        guard let deviceQuestionID = deviceQuestion.recordID else { return }
        cloudKitManager.fetchRecord(withID: deviceQuestionID) { (record, error) in
            guard let pulledRecord = record else { return }
            guard let pulledQuestion = Question(record: pulledRecord) else { return }
            if pulledQuestion.votes == deviceQuestion.votes {
                if SessionController.sharedController.questionsVotedOn.contains(deviceQuestion) {
                    deviceQuestion.votes -= 1
                    guard let indexOfDeviceQuestion = SessionController.sharedController.questionsVotedOn.index(of: deviceQuestion) else { return }
                    DispatchQueue.main.async {
                        SessionController.sharedController.questionsVotedOn.remove(at: indexOfDeviceQuestion)
                        self.tableView.reloadData()
                    }
                    let record = CKRecord(statement: deviceQuestion.statement, recordID: deviceQuestionID, votes: deviceQuestion.votes, session: SessionController.sharedController.activeSession!)
                    self.cloudKitManager.modifyRecords([record], perRecordCompletion: { (record, error) in
                        if let record = record {
                            print(record)
                        }
                    }, completion: { (records, error) in
                        if let records = records {
                            print(records.count)
                        }
                    })
                } else {
                    deviceQuestion.votes += 1
                    DispatchQueue.main.async {
                        SessionController.sharedController.questionsVotedOn.append(deviceQuestion)
                        self.tableView.reloadData()
                    }
                    let record = CKRecord(statement: deviceQuestion.statement, recordID: pulledQuestion.recordID!, votes: deviceQuestion.votes, session: SessionController.sharedController.activeSession!)
                    self.cloudKitManager.modifyRecords([record], perRecordCompletion: { (record, error) in
                        if let record = record {
                            print(record)
                        }
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }, completion: { (records, error) in
                        if let records = records {
                            print(records.count)
                        }
                    })
                }
            } else {
               SessionController.sharedController.fullSync()
            }
        }
    }
    
    func setupSessionLabels() {
        guard let session = SessionController.sharedController.activeSession else { return }
        self.title = session.title
        
        let info = UIBarButtonItem(image: UIImage(named: "informationbubble"), style: .plain, target: self, action: #selector(infoTapped))
        let addQuestion = UIBarButtonItem(image: UIImage(named: "speechbubble"), style: .plain, target: self, action: #selector(menuTapped))
        navigationItem.rightBarButtonItems = [info, addQuestion]
    }
    
    func reloadTable() {
        self.tableView.reloadData()
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
    @IBAction func dismissTapped(_ sender: Any) {
        viewOfSpencer.removeFromSuperview()
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
