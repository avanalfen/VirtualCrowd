//
//  OpeningScreenViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class OpeningScreenViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var joinCrowdCodeEntryTextField: UITextField!
    @IBOutlet weak var createCrowdTitleTextEntry: UITextField!
    @IBOutlet weak var createCrowdTimeLimitEntry: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: Properties
    
    var crowdCreatedUUID: String = ""
    var isThereATitle: Bool = false
    var isThereATime: Bool = false
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: deleteThis
        SessionController.sharedController.mockData()
        setupTextfields()
        self.createCrowdTimeLimitEntry.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        joinButton.isEnabled = false
        createButton.isEnabled = false
    }
    
    // MARK: Textfields
    
    @IBAction func joinCodeTextChanged(_ sender: UITextField) {
        if sender.text != "" {
            joinButton.isEnabled = true
        } else {
            joinButton.isEnabled = false
        }
    }
    
    func setupTextfields() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpeningScreenViewController.resignKeyboard))
        view.addGestureRecognizer(tap)
        
        self.joinCrowdCodeEntryTextField.autocapitalizationType = .allCharacters
        
        createButton.isEnabled = false
        joinButton.isEnabled = false
        
        doNothing()
    }
    
    // MARK: Button Functions
    
    @IBAction func createTitleTextChanged(_ sender: UITextField) {
        if sender.text != "" {
            isThereATitle = true
        } else {
            isThereATitle = false
        }
        enableCreateButton()
        print(sender.text)
    }
    
    @IBAction func createTimeTextChanged(_ sender: UITextField) {
        if sender.text != "" {
            isThereATime = true
        } else {
            isThereATime = false
        }
        enableCreateButton()
        print(sender.text)
    }
    
    func enableCreateButton() {
        if isThereATime && isThereATitle {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    
    @IBAction func JoinSessionPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func createSessionButtonPressed(_ sender: UIButton) {
        guard let title = createCrowdTitleTextEntry.text, let time = Double(createCrowdTimeLimitEntry.text!) else { return }
        let code = SessionController.sharedController.randomCodeGenerator()
        let session = Session(title: title, identifier: UUID().uuidString, code: code, questions: [], timeLimit: time, isActive: true, date: Date(), crowdNumber: 1)
        self.crowdCreatedUUID = session.identifier
        SessionController.sharedController.sessions.append(session)
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
            let sessionArray = SessionController.sharedController.sessions.filter({ $0.identifier == self.crowdCreatedUUID })
            let sessionToSend = sessionArray[0]
            destinationVC?.session = sessionToSend
            resetTextfields()
        }
        
        if segue.identifier == "joinSegue" {
            guard let text = self.joinCrowdCodeEntryTextField.text else { return }
            let destinationVC = segue.destination as? SessionViewController
            let sessionArray = SessionController.sharedController.sessions.filter({ $0.code == text })
            let sessionToSend = sessionArray[0]
            destinationVC?.session = sessionToSend
            resetTextfields()
        }
    }
    
    // MARK: deleteThis
    func doNothing() {
        
    }
}
