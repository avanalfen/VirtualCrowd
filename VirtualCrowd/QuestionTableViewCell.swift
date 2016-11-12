//
//  QuestionTableViewCell.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

class QuestionTableViewCell: UITableViewCell {
    
    
    
    // MARK: Properties
    
    let cloudKitManager = CloudKitManager()
    
    var question: Question?
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var upVoteButton: UIButton!
    
    // MARK: Functions
    
    @IBAction func VoteButtonPressed(_ sender: UIButton) {
        
    }
    
    func updateWith(question: Question) {
        questionTextLabel.text = question.statement
    }
    
    // MARK: Provided Functions

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
