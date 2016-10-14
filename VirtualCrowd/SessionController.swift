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
    //----------------------------------------------------------------------------------------------------------------------
    
    var sessions: [Session] = []
    var inactiveSessions: [Session] = []
    
    // MARK: functions
    //----------------------------------------------------------------------------------------------------------------------

    func createSession(title: String, code: String, timeLimit: TimeInterval) {
        let session = Session(title: title, identifier: UUID().uuidString, code: code, questions: [], timeLimit: timeLimit, isActive: true, endDate: Date(), crowdNumber: 1, startDate: Date())
        sessions.append(session)
    }
    
    func addQuestionToSession(statement: String, session: Session) {
        let session = session
        let newQuestion = Question(statement: statement, session: session)
        session.questions.append(newQuestion)
    }
    
    func sessionNowInactive(session: Session) {
        
    }
    
    func addVoteToQuestion(question: Question) {
        if question.votedOn == false {
            question.upVotes += 1
            question.votedOn = true
        } else {
            question.upVotes -= 1
            question.votedOn = false
        }
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
    
    // MARK: deleteThis
    //----------------------------------------------------------------------------------------------------------------------

    func mockData() {
        let session = Session(title: "Test", identifier: UUID().uuidString, code: "ABC123", questions: [], timeLimit: 60, isActive: false, endDate: Date(), crowdNumber: 1, startDate: Date())
        let q1 = Question(statement: "Here is a long sentence to see if the text will wrap to another line", session: session)
        let q2 = Question(statement: "Explain more on that subject please", session: session)
        let q3 = Question(statement: "I'm confused about *subject*", session: session)
        session.questions.append(q1)
        session.questions.append(q2)
        session.questions.append(q3)
        sessions.append(session)
        
        let session2 = Session(title: "Testing Session", identifier: UUID().uuidString, code: "123ABC", questions: [], timeLimit: 60, isActive: false, endDate: Date(), crowdNumber: 1, startDate: Date())
        let q4 = Question(statement: "What do you want?", session: session2)
        let q5 = Question(statement: "Explain more please", session: session2)
        let q6 = Question(statement: "I'm confused", session: session2)
        session2.questions.append(q4)
        session2.questions.append(q5)
        session2.questions.append(q6)
        sessions.append(session2)
    }
}
