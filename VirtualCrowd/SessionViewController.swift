//
//  SessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate, cellVoteWasTappedDelegate {
    
    // MARK: Properties
    //----------------------------------------------------------------------------------------------------------------------
    
    
    var session: Session?
    var questionsArray: [Question] = []
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
    let cloudKitManager = CloudKitManager()
    
    // MARK: Outlets
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var sessionEndTimeLabel: UILabel!
    @IBOutlet weak private var sessionCodeLabel: UILabel!
    @IBOutlet private var viewOfSpencer: UIVisualEffectView!
    @IBOutlet weak private var sessionQuestionsTableView: UITableView!
    
    // MARK: View Setup
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSessionLabels()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getQuestions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: TableView
    //----------------------------------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let previousCellIndexPath = previousCellIndexPath {
            guard let cell = tableView.cellForRow(at: previousCellIndexPath) as? QuestionTableViewCell else { return }
            cell.notesLabel.isHidden = true
            cell.notesTextField.isHidden = true
            cell.notesTextField.resignFirstResponder()
            cell.delegate = self
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
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell else { return QuestionTableViewCell() }
        let ip = indexPath
        let indexOfQuestion = indexPath.section + indexPath.row
        let question = self.questionsArray[indexOfQuestion]
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        
        cell.updateWith(question: question)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: Functions
    //----------------------------------------------------------------------------------------------------------------------
    
    func getQuestions() {
        
        guard let session = self.session else { return }
        
        let sessionID = session.recordID
        
        let record = CKRecord(recordType: Session.recordType, recordID: sessionID)
        
        let reference = CKReference(record: record, action: .none)
        
        let predicate = NSPredicate(format: "referenceKey == %@", reference)
        
        cloudKitManager.fetchRecordsWithType(Question.recordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            
            if let records = records {
                DispatchQueue.main.async {
                    let questionsArray1 = records.flatMap { Question(record: $0) }
                    self.questionsArray = questionsArray1
                    self.sessionQuestionsTableView.reloadData()
                }
            }
        }
       
    }
    
    @IBAction func addQuestionButtonTapped(_ sender: UIBarButtonItem) {
        getQuestions()
        let alert = UIAlertController(title: "Enter Question", message: nil, preferredStyle: .alert)
        alert.title = "Enter Question"
        
        var submitTextField: UITextField?
        alert.addTextField { (textField) in
            submitTextField = textField
        }
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let question = submitTextField?.text else { return }
             self.addQuestionSubmitButtonTapped(question: question)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submit)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addQuestionSubmitButtonTapped(question: String) {
        guard let session = self.session else { return }
        QuestionController.sharedController.createQuestionRecordFrom(statement: question, session: session)
        getQuestions()
    }
    
    func setupSessionLabels() {
        guard let session = self.session else { return }
        let endTime = date(date: session.endDate).timeR
        self.sessionCodeLabel.text = "Code: \(session.code)"
        self.sessionEndTimeLabel.text = "\(endTime)"
        sessionQuestionsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: sessionQuestionsTableView.frame.width, height: 20)

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("\(session.title)", for: .normal)
//        button.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        _ = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(getQuestions), userInfo: nil, repeats: true)
        
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
    
    func upVoteButtonPressed(cell: QuestionTableViewCell) {
        guard let question = cell.question else { return }
        let vote = Vote(vote: true)
        VoteController.sharedController.createVoteRecordWith(question: question, vote: vote)
        cell.updateWith(question: question)
        sessionQuestionsTableView.reloadData()
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
