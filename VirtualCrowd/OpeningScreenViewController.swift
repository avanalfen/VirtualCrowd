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
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: Button Functions
    
    @IBAction func JoinSessionPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func createSessionButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func pastSessionsButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
}
