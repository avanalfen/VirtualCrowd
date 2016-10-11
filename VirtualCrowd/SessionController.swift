//
//  SessionController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

class SessionController {
    
    static let sharedController = SessionController()
    
    // MARK: properties
    
    var activeSessions: [Session] = []
    var inactiveSessions: [Session] = []
    
    // MARK: functions
    
    func createSession(title: String, code: String, timeLimit: TimeInterval) {
        let session = Session(title: title, id: UUID(), code: code, questions: [], timeLimit: timeLimit, isActive: true, date: Date(), crowdNumber: 1)
        activeSessions.append(session)
    }
    
    func addQuestionToSession(statement: String, session: Session) {
        var session = session
        let newQuestion = Question(statement: statement, session: session)
        session.questions.append(newQuestion)
    }
    
    func sessionNowInactive(session: Session) {
        let session = session
        if let index = activeSessions.index(where: {$0 == session}) {
        activeSessions.remove(at: index)
        }
        inactiveSessions.append(session)
    }
    
    // MARK: random code generator
    
    func randomCodeGenerator() -> String {
        let characters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomCodeString: NSMutableString = NSMutableString(capacity: 5)
        
        for _ in 0...4 {
            let length = UInt32 (characters.length)
            let random = arc4random_uniform(length)
            randomCodeString.appendFormat("%C", characters.character(at: Int(random)))
        }
        return randomCodeString as String
    }
    
    // MARK: deleteThis
    func mockData() {
        let session = Session(title: "Test", id: UUID(), code: randomCodeGenerator(), questions: [], timeLimit: 60, isActive: false, date: Date(), crowdNumber: 1)
        _ = Question(statement: "What do you want?", session: session)
        _ = Question(statement: "Explain more please", session: session)
        _ = Question(statement: "I'm confused", session: session)
        inactiveSessions.append(session)
        
        let session2 = Session(title: "Test", id: UUID(), code: randomCodeGenerator(), questions: [], timeLimit: 60, isActive: false, date: Date(), crowdNumber: 1)
        _ = Question(statement: "What do you want?", session: session2)
        _ = Question(statement: "Explain more please", session: session2)
        _ = Question(statement: "I'm confused", session: session2)
        activeSessions.append(session2)
    }
}
