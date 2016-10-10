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
    
    func createSession(title: String, timeLimit: TimeInterval) {
        let session = Session(title: title, id: UUID(), code: randomCodeGenerator(), questions: [], timeLimit: timeLimit, isActive: true, date: Date(), crowdNumber: 1)
        activeSessions.append(session)
    }
    
    func addQuestionToSession(statement: String, session: Session) {
        var session = session
        let newQuestion = Question(statement: statement, session: session)
        session.questions.append(newQuestion)
        
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
}
