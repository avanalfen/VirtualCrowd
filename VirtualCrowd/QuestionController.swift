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
    
    static let sharedController = QuestionController()
    
    @discardableResult func createQuestionRecordFrom(statement: String, session: Session) -> Question? {
        
        guard let sessionID = session.recordID else { return nil }
        
        let ckManager = CloudKitManager()
        
        let ID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: ID)
        
        let question = Question(statement: statement, recordID: recordID)
        
        let record = CKRecord(recordType: "Question", recordID: recordID)
        
        let reference = CKReference(recordID: sessionID, action: .deleteSelf)
        
        record.setObject(question.statement as CKRecordValue?, forKey: Question.kStatement)
        record.setObject(reference, forKey: Question.kReference)
        
        
        
        ckManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("QuestionController.CreateRecordFrom.SaveRecord \n \(error?.localizedDescription)")
            }
        }
        return question
    }
}
