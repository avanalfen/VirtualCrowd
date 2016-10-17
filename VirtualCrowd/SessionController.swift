//
//  SessionController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class SessionController {
    
    let kStart = "startKey"
    let kEnd = "endKey"
    let kIdentifier = "identifierKey"
    let kCode = "codeKey"
    let kActive = "isActiveKey"
    let kUser = "userKey"
    
    static let sharedController = SessionController()
    
    // MARK: properties
    //----------------------------------------------------------------------------------------------------------------------
    
    var sessions: [Session] = []
    var inactiveSessions: [Session] = []
    
    // MARK: functions
    //----------------------------------------------------------------------------------------------------------------------

    @discardableResult func createSession(title: String, timeLimit: TimeInterval) -> Session {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(timeLimit * 60)
        let identifier = UUID().uuidString
        let code = randomCodeGenerator()
        let isActive = true
        let startingCrowdNumber = 1
        
        let session = Session(title: title, identifier: identifier, code: code, timeLimit: timeLimit, isActive: isActive, endDate: endDate, crowdNumber: startingCrowdNumber, startDate: startDate)
        
        sessions.append(session)
        return session
    }
    
    func addQuestionToSession(statement: String, session: Session) {
        let session = session
        let newQuestion = Question(statement: statement, session: session)
        // MARK: fix this
    }
    
    func sessionNowInactive(session: Session) {
        session.isActive = false
    }
    
    func addVoteToQuestion(question: Question) {
       // MARK: fix this
    }
    
    func addNotesToQuestion(text: String, question: Question) {
        question.notes = text
    }
    
    // MARK: random code generator
    //----------------------------------------------------------------------------------------------------------------------

    func randomCodeGenerator() -> String {
        let characters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let randomCodeString: NSMutableString = NSMutableString(capacity: 5)
        
        for _ in 0...4 {
            let length = UInt32 (characters.length)
            let random = arc4random_uniform(length)
            randomCodeString.appendFormat("%C", characters.character(at: Int(random)))
        }
        return randomCodeString as String
    }
    
    // MARK: cloudKit
    
    func createRecordWith(session: Session) -> CKRecordID {
        
        let cloudKitManager = CloudKitManager()
        
        let ID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: ID)
        
        let record = CKRecord(recordType: "Session", recordID: recordID)
        
        record.setObject(session.startDate as CKRecordValue?, forKey: kStart)
        record.setObject(session.endDate as CKRecordValue?, forKey: kEnd)
        record.setObject(session.identifier as CKRecordValue?, forKey: kIdentifier)
        record.setObject(session.code as CKRecordValue?, forKey: kCode)
        record.setObject(session.isActive as CKRecordValue?, forKey: kActive)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("SessionController.createRecordWith.saveRecord. \(error?.localizedDescription)")
            }
        }
        return recordID
    }
    
    func createRecordForUserWhoEnters(session: Session) {
        let cloudKitManager = CloudKitManager()
        
        let id = UUID().uuidString
        
        let recordID = CKRecordID(recordName: id)
        
        let record = CKRecord(recordType: "User", recordID: recordID)
        
        let reference = CKReference(recordID: session.recordID, action: .deleteSelf)
        
        record.setObject(reference, forKey: kUser)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("SessionController.createRecordForUserWhoEnters.saveRecord. \n \(error?.localizedDescription)")
            }
        }
    }
    
    
    
}
