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
    
    @IBOutlet weak var currentCrowdButton: UIButton!
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
        SessionController.sharedController.viewIsBeingShownComingFromSession = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        createButton.isEnabled = false
        joinButton.isEnabled = false
        
        if SessionController.sharedController.viewIsBeingShownComingFromSession! {
            currentCrowdButton.isHidden = false
        } else {
            currentCrowdButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SessionController.sharedController.viewIsBeingShownComingFromSession = false
    }
    
    // MARK: Textfields
    
    @IBAction func joinCodeTextChanged(_ sender: UITextField) {
        if sender.text != "" {
            joinButton.isEnabled = true
        } else {
            joinButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == joinCrowdCodeEntryTextField {
            joinSession()
        }
        return true
    }
    
    
    
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
        joinSession()
    }
    
    func joinSession() {
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
                            
                            if (newSession?.endDate)! < Date() {
                                let alert = UIAlertController(title: "Your Crowd has expired!", message: "Create a new one!", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let sessionViewController = storyboard.instantiateViewController(withIdentifier: "sessionView") as? SessionViewController else { return }
                                sessionViewController.session = newSession
                                guard let newSession = newSession else { return }
                                if SessionController.sharedController.joinedSessions.contains(newSession) {
                                    
                                } else {
                                    SessionController.sharedController.joinedSessions.insert(newSession, at: 0)
                                }
                                self.navigationController?.pushViewController(sessionViewController, animated: true)
                                self.clearTextFields()
                                self.resignKeyboard()
                            }
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
        guard let session = self.session else { return }
        SessionController.sharedController.joinedSessions.insert(session, at: 0)
        
    }
    
    @IBAction func currentCrowdButtonTapped() {
        guard let nextSessionViewController = storyboard?.instantiateViewController(withIdentifier: "sessionView") as? SessionViewController else { return }
        nextSessionViewController.session = SessionController.sharedController.previousSession
        self.navigationController?.pushViewController(nextSessionViewController, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createSession" {
            let destinationVC = segue.destination as? SessionViewController
            destinationVC?.session = self.session
            resetTextfields()
        }
    }
}
