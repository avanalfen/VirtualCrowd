//
//  QuestionController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/17/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class QuestionController {
    
    let kStatement = "statementKey"
    let kVotedOn = "votedOnKey"
    let kReference = "referenceKey"
    
    
    func createRecordFrom(question: Question, session: Session) -> CKRecordID {
        let ckManager = CloudKitManager()
        
        let ID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: ID)
        
        let record = CKRecord(recordType: "Question", recordID: recordID)
        
        let reference = CKReference(recordID: session.recordID, action: .deleteSelf)
        
        record.setObject(question.statement as CKRecordValue?, forKey: kStatement)
        record.setObject(reference, forKey: kReference)
        
        ckManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("QuestionController.CreateRecordFrom.SaveRecord /n \(error?.localizedDescription)")
            }
        }
        return recordID
    }
    
}
