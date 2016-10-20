//
//  QuestionTableViewCell.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit
import CloudKit

protocol cellVoteWasTappedDelegate: class {
    func upVoteButtonPressed(cell: QuestionTableViewCell)
}

class QuestionTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var votes: [Vote] = []
    let cloudKitManager = CloudKitManager()
    weak var delegate: cellVoteWasTappedDelegate?
    
    var question: Question?
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var upVoteButton: UIButton!
    
    // MARK: Functions
    
    @IBAction func VoteButtonPressed(_ sender: UIButton) {
        delegate?.upVoteButtonPressed(cell: self)
    }
    
    func updateWith(question: Question) {
        guard let questionID = question.recordID else { return }
        questionTextLabel.text = question.statement
        upVoteButton.setTitle("\(question.votes)", for: .normal)
        
        let predicate = NSPredicate(format: "referenceKey == %@", questionID)
        
        cloudKitManager.fetchRecordsWithType(Vote.recordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if error != nil {
                print("Error fetching votes for a question. \n \(error?.localizedDescription)")
            }
            
            if let records = records {
                DispatchQueue.main.async {
                    let arrayOfVotes = records.flatMap { Vote(record: $0) }
                    self.votes = arrayOfVotes
                    self.upVoteButton.setTitle("\(self.votes.count)", for: .normal)
                }
            }
        }
        
        let notePredicate = NSPredicate(format: "referenceKey == %@", questionID)
        
        cloudKitManager.fetchRecordsWithType(Note.recordType, predicate: notePredicate, recordFetchedBlock: nil) { (records, error) in
            if error != nil {
                print("Error fetching notes for question. \n \(error?.localizedDescription)")
            } else {
                if let records = records {
                    DispatchQueue.main.async {
                        let note = records.flatMap { Note(record: $0) }.first
                        if note != nil {
                            self.notesTextField.text = note?.note
                        } else {
                            self.notesTextField.text = ""
                        }
                    }
                }
            }
        }
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
