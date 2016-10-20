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
    
    static let sharedController = SessionController()
    
    // MARK: properties
    //----------------------------------------------------------------------------------------------------------------------
    
    var previousSession: Session?
    var viewIsBeingShownComingFromSession: Bool?
    var sessions: [Session] = []
    var inactiveSessions: [Session] = []
    var joinedSessions: [Session] = []
    var sortedJoinedSessions: [Session] {
        return joinedSessions.sorted(by: { $0.0.endDate > $0.1.endDate })
    }
    var sessionReference: CKReference?
    
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
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        let session = Session(title: title, identifier: identifier, code: code, timeLimit: timeLimit, isActive: isActive, endDate: endDate, crowdNumber: startingCrowdNumber, startDate: startDate, recordID: recordID)
        
        createRecordWith(session: session, sessionRecordID: recordID)
        
        sessions.append(session)
        return session
    }
    
    func addQuestionToSession(statement: String, session: Session) {
        QuestionController.sharedController.createQuestionRecordFrom(statement: statement, session: session)
    }
    
    func sessionNowInactive(session: Session) {
        
    }
    
    func addVoteToQuestion(question: Question) {
       
    }
    
    func addNotesToQuestion(text: String, question: Question) {
        // MARK: fix this
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
    
    func createRecordWith(session: Session, sessionRecordID: CKRecordID) {
        
        let cloudKitManager = CloudKitManager()
        
        let record = CKRecord(recordType: "Session", recordID: sessionRecordID)
        
        let reference = CKReference(record: record, action: .none)
        
        record.setObject(session.title as CKRecordValue?, forKey: Session.kTitle)
        record.setObject(session.startDate as CKRecordValue?, forKey: Session.kStart)
        record.setObject(session.endDate as CKRecordValue?, forKey: Session.kEnd)
        record.setObject(session.identifier as CKRecordValue?, forKey: Session.kIdentifier)
        record.setObject(session.code as CKRecordValue?, forKey: Session.kCode)
        record.setObject(session.isActive as CKRecordValue?, forKey: Session.kActive)
        record.setObject(session.timeLimit as CKRecordValue?, forKey: Session.kTimeLimit)
        record.setObject(session.crowdNumber as CKRecordValue?, forKey: Session.kCrowdNumber)
        record.setObject(reference, forKey: Session.kReference)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("SessionController.createRecordWith.saveRecord.\n \(error?.localizedDescription)")
            }
            
        }
    }
    
    func createRecordForUserWhoEnters(session: Session, recordID: CKRecordID) {
        
        let identifier = session.recordID
        let cloudKitManager = CloudKitManager()
        
        let record = CKRecord(recordType: "User", recordID: recordID)
        
        let reference = CKReference(recordID: identifier, action: .deleteSelf)
        
        record.setObject(reference, forKey: Session.kUser)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("SessionController.createRecordForUserWhoEnters.saveRecord. \n \(error?.localizedDescription)")
            }
        }
    }
    
    
    
}
