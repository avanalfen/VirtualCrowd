//
//  QuestionTableViewCell.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

protocol UpVoteButtonPressedDelegate: class {
    func addVoteToQuestion(deviceQuestion: Question)
}

class QuestionTableViewCell: UITableViewCell {
    
    weak var upVoteDelegate: UpVoteButtonPressedDelegate?
    
    // MARK: Properties
    
    let cloudKitManager = CloudKitManager()
    
    var question: Question?
    
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var upVoteCount: UILabel!
    
    // MARK: Functions
    
    @IBAction func VoteButtonPressed(_ sender: UIButton) {
        self.upVoteButton.isEnabled = false
        guard let question = self.question else { return }
        upVoteDelegate?.addVoteToQuestion(deviceQuestion: question)
        self.upVoteButton.isEnabled = true
    }
    
    func updateWith(question: Question) {
        self.question = question
        questionTextLabel.text = question.statement
        upVoteCount.text = "\(question.votes)"
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
