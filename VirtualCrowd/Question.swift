//
//  Question.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Question {
    
    static let kStatement = "statementKey"
    static let kReference = "referenceKey"
    static let recordType = "Question"
    static let kRecordID = "recordIDKey"
    static let kVotes = "votesKey"
    
    let statement: String
    let recordID: CKRecordID?
    var votes: Int
    
    init(statement: String, recordID: CKRecordID?, votes: Int = 0) {
        self.statement = statement
        self.recordID = recordID
        self.votes = votes
    }
    
    convenience init?(record: CKRecord) {
        guard let statement = record[Question.kStatement] as? String,
            let recordID = record[Question.kRecordID] as? CKReference,
            let votes = record[Question.kVotes] as? Int
            else { print("Bad news");
                return nil }
        self.init(statement: statement, recordID: recordID.recordID, votes: votes)
    }
}

