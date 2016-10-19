//
//  OpeningScreenViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

class OpeningScreenViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var theInceptionView: UIView!
    @IBOutlet weak var joinCrowdCodeEntryTextField: JoinCrowdTextField!
    @IBOutlet weak var createCrowdTitleTextEntry: UITextField!
    @IBOutlet weak var createCrowdTimeLimitEntry: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: Properties
    
    var session: Session?
    let cloudKitManager = CloudKitManager()
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: deleteThis
        setupTextfields()
        theInceptionView.layer.cornerRadius = 5
        theInceptionView.layer.masksToBounds = true
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 1) { 
//            self.view.transform = CGAffineTransform(translationX: 0, y: -200)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        createButton.isEnabled = false
        joinButton.isEnabled = false
    }
    
    // MARK: Textfields
    
    @IBAction func joinCodeTextChanged(_ sender: UITextField) {
        if sender.text != "" {
            joinButton.isEnabled = true
        } else {
            joinButton.isEnabled = false
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.4) { 
//            self.view.transform = CGAffineTransform(translationX: 0, y: -200)
//        }
//    }
    
    
    
    func setupTextfields() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpeningScreenViewController.resignKeyboard))
        view.addGestureRecognizer(tap)
        
        self.joinCrowdCodeEntryTextField.autocapitalizationType = .allCharacters
        self.createCrowdTimeLimitEntry.layer.borderColor = UIColor.blue.cgColor
        self.createCrowdTitleTextEntry.layer.borderColor = UIColor.blue.cgColor
        self.joinCrowdCodeEntryTextField.layer.borderColor = UIColor.blue.cgColor
        self.createCrowdTimeLimitEntry.layer.borderWidth = 1
        self.createCrowdTitleTextEntry.layer.borderWidth = 1
        self.joinCrowdCodeEntryTextField.layer.borderWidth = 1
        self.createCrowdTimeLimitEntry.keyboardType = .numberPad
        self.createCrowdTimeLimitEntry.delegate = self
        
    }
    
    // MARK: Button Functions
    
    @IBAction func createTitleTextChanged(_ sender: UITextField) {
        enableCreateButton()
        print(sender.text)
    }
    
    @IBAction func createTimeTextChanged(_ sender: UITextField) {
        enableCreateButton()
        print(sender.text)
    }
    
    func enableCreateButton() {
        if createCrowdTimeLimitEntry.text != "" && createCrowdTitleTextEntry.text != "" {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    
    @IBAction func JoinSessionPressed(_ sender: UIButton) {
        guard let enteredCode = self.joinCrowdCodeEntryTextField.text else { return }
        if enteredCode != "" {
            let predicate = NSPredicate(format: "codeKey == %@", enteredCode)
            cloudKitManager.fetchRecordsWithType(Session.recordType, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                
                if error != nil {
                    print("Problem finding correct session when join button was pressed \n \(error?.localizedDescription)")
                }
                
                if let records = records {
                    let newSession = records.flatMap { Session(record: $0) }.first
                    
                    if newSession != nil {
                        DispatchQueue.main.async {
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let sessionViewController = storyboard.instantiateViewController(withIdentifier: "sessionView") as? SessionViewController else { return }
                            sessionViewController.session = newSession
                            self.navigationController?.pushViewController(sessionViewController, animated: true)
                            self.clearTextFields()
                            self.resignKeyboard()
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Wrong Code", message: "Check code and try again!", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: {
                                self.resignKeyboard()
                                self.clearTextFields()
                            })
                            self.joinCrowdCodeEntryTextField.shake()
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func createSessionButtonPressed(_ sender: UIButton) {
        guard let title = createCrowdTitleTextEntry.text, let time = Double(createCrowdTimeLimitEntry.text!) else { return }
        self.session = SessionController.sharedController.createSession(title: title, timeLimit: time)
        
    }
    
    @IBAction func pastSessionsButtonTapped(_ sender: UIButton) {
        
    }
    
    func clearTextFields() {
        joinCrowdCodeEntryTextField.text = ""
        createCrowdTitleTextEntry.text = ""
        createCrowdTimeLimitEntry.text = ""
    }
    
    func resignKeyboard() {
        joinCrowdCodeEntryTextField.resignFirstResponder()
        createCrowdTimeLimitEntry.resignFirstResponder()
        createCrowdTitleTextEntry.resignFirstResponder()
    }
    
    func resetTextfields() {
        resignKeyboard()
        clearTextFields()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "createSession" {
            let destinationVC = segue.destination as? SessionViewController
            destinationVC?.session = self.session
            resetTextfields()
        }
        
        //        if segue.identifier == "joinSegue" {
        //            guard let text = self.joinCrowdCodeEntryTextField.text else { return }
        //            let destinationVC = segue.destination as? SessionViewController
        //            let sessionArray = SessionController.sharedController.sessions.filter({ $0.code == text })
        //            let sessionToSend = sessionArray[0]
        //            destinationVC?.session = sessionToSend
        //            resetTextfields()
        //        }
    }
    
    func mockData() {
        let id = CKRecordID(recordName: "Session")
        let session = Session(title: "This is a test", identifier: UUID().uuidString, code: "XDD3K8", timeLimit: 45, isActive: true, endDate: Date(), crowdNumber: 55, startDate: Date(), recordID: id)
        
        let note = Note(note: "This is a note")
        
        let vote = Vote(vote: true)
        
        SessionController.sharedController.createRecordWith(session: session, sessionRecordID: session.recordID)
        let question = QuestionController.sharedController.createQuestionRecordFrom(statement: "This is a test question", session: session)
        guard let question2 = question else { return }
        VoteController.sharedController.createVoteRecordWith(question: question2, vote: vote)
        NoteController.sharedController.createNoteRecordFor(question: question2, note: note)
    }
}




















