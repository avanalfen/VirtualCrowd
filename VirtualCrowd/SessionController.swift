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
    
    var activeSessions: [Session] = []
    var inactiveSessions: [Session] = []
    
    func createSession(title: String, timeLimit: TimeInterval) {
        // FIX THIS
        let session = Session(title: title, id: UUID(), code: randomCodeGenerator(), questions: nil, timeLimit: TimeInterval(), isActive: true, date: Date(), crowdNumber: 5)
        
        self.activeSessions.append(session)
    }
    
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
