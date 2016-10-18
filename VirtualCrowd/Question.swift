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
    
    let statement: String
    let recordID: CKRecordID?
    
    init(statement: String, recordID: CKRecordID?) {
        self.statement = statement
        self.recordID = recordID
    }
    
    convenience init?(record: CKRecord) {
        guard let statement = record[Question.kStatement] as? String else { return nil }
        guard let recordID = record[Question.kRecordID] as? CKRecordID else { return nil }
        self.init(statement: statement, recordID: recordID)
    }
}

