//
//  OpeningScreenViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class OpeningScreenViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var joinCrowdCodeEntryTextField: UITextField!
    @IBOutlet weak var createCrowdTitleTextEntry: UITextField!
    @IBOutlet weak var createCrowdTimeLimitEntry: UITextField!
    
    var crowdCreatedUUID: String = ""
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: deleteThis
        SessionController.sharedController.mockData()
        doNothing()
    }
    
    
    // MARK: Button Functions
    
    @IBAction func JoinSessionPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func createSessionButtonPressed(_ sender: UIButton) {
        guard let title = createCrowdTitleTextEntry.text, let time = Double(createCrowdTimeLimitEntry.text!) else { return }
        let code = SessionController.sharedController.randomCodeGenerator()
        let session = Session(title: title, identifier: UUID().uuidString, code: code, questions: [], timeLimit: time, isActive: true, date: Date(), crowdNumber: 1)
        self.crowdCreatedUUID = session.identifier
        SessionController.sharedController.activeSessions.append(session)
        doNothing()
    }
    
    @IBAction func pastSessionsButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "createSession" {
            let destinationVC = segue.destination as? SessionViewController
            let sessionArray = SessionController.sharedController.activeSessions.filter({ $0.identifier == self.crowdCreatedUUID })
            let sessionToSend = sessionArray[0]
            destinationVC?.session = sessionToSend
        }
    }
    
    // MARK: deleteThis
    func doNothing() {
        
    }
}
