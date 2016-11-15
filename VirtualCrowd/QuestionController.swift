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
    
    let cloudKitManager = CloudKitManager.sharedController
    
    static let sharedController = QuestionController()
    
    @discardableResult func createQuestionRecordFrom(statement: String, session: Session) -> Question? {
        
        let sessionID = session.recordID
        
        let ID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: ID)
        
        let recordIDReference = CKReference(recordID: recordID, action: .none)
        
        let question = Question(statement: statement, recordID: recordID)
        
        let record = CKRecord(recordType: "Question", recordID: question.recordID!)
        
        let referenceToSession = CKReference(recordID: sessionID, action: .deleteSelf)
        
        record.setObject(question.statement as CKRecordValue?, forKey: Question.kStatement)
        record.setObject(recordIDReference, forKey: Question.kRecordID)
        record.setObject(referenceToSession, forKey: Question.kReference)
        record.setObject(question.votes as CKRecordValue?, forKey: Question.kVotes)
        record.setObject(question.notes as CKRecordValue?, forKey: Question.kNotes)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("QuestionController.CreateRecordFrom.SaveRecord \n \(error?.localizedDescription)")
            }
        }
        return question
    }
}
