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
    
    @IBOutlet weak var theInceptionView: UIView!
    @IBOutlet weak var joinCrowdCodeEntryTextField: JoinCrowdTextField!
    @IBOutlet weak var createCrowdTitleTextEntry: UITextField!
    @IBOutlet weak var createCrowdTimeLimitEntry: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: Properties
    
    var session: Session?
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: deleteThis
        SessionController.sharedController.mockData()
        setupTextfields()
        theInceptionView.layer.cornerRadius = 5
        theInceptionView.layer.masksToBounds = true
        joinCrowdCodeEntryTextField.delegate = self
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
        guard let text = self.joinCrowdCodeEntryTextField.text else { return }
        
        if let session = SessionController.sharedController.findSession(text) {
            guard let sessionViewController = self.storyboard?.instantiateViewController(withIdentifier: "sessionView") as? SessionViewController else { return }
            sessionViewController.session = session
            
            self.clearTextFields()
            self.resignKeyboard()
            
            present(sessionViewController, animated: true, completion: nil)
            
        } else {
            
            joinCrowdCodeEntryTextField.shake()
            
            let alert = UIAlertController(title: "Wrong Code", message: "Check code and try again!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: { 
                self.resignKeyboard()
                self.clearTextFields()
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createSession" {
            let destinationVC = segue.destination as? SessionViewController
            destinationVC?.session = self.session
            resignKeyboard()
            clearTextFields()
        }
    }
}
