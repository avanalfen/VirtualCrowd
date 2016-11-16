//
//  Question.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Question: Equatable {
    
    static let kStatement = "statementKey"
    static let kReference = "referenceKey"
    static let recordType = "Question"
    static let kRecordID = "recordIDKey"
    static let kVotes = "votesKey"
    static let kNotes = "notesKey"
    
    let statement: String
    let recordID: CKRecordID?
    var votes: Int
    var notes: String
    
    init(statement: String, recordID: CKRecordID?, votes: Int = 0, notes: String = "") {
        self.statement = statement
        self.recordID = recordID
        self.votes = votes
        self.notes = notes
    }
    
    convenience init?(record: CKRecord) {
        guard let statement = record[Question.kStatement] as? String,
            let recordID = record[Question.kRecordID] as? CKReference,
            let votes = record[Question.kVotes] as? Int,
            let notes = record[Question.kNotes] as? String
            else { print("Bad news");
                return nil }
        self.init(statement: statement, recordID: recordID.recordID, votes: votes, notes: notes)
    }
}

func ==(lhs: Question, rhs: Question) -> Bool {
    return lhs.recordID == rhs.recordID
}
