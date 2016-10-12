//
//  Session.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

class Session: Equatable {
    
    let title: String
    let identifier: String
    let code: String
    var questions: [Question]
    let timeLimit: TimeInterval
    let isActive: Bool
    let date: Date
    let crowdNumber: Int
    
    var fireDate: NSDate? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return nil }
        let fireDateFromThisMorning = NSDate(timeInterval: timeLimit, since: thisMorningAtMidnight as Date)
        return fireDateFromThisMorning
    }
    
    init(title: String, identifier: String, code: String, questions: [Question], timeLimit: TimeInterval, isActive: Bool,  date: Date, crowdNumber: Int) {
        self.title = title
        self.identifier = identifier
        self.code = code
        self.questions = questions
        self.timeLimit = timeLimit
        self.isActive = isActive
        self.date = date
        self.crowdNumber = crowdNumber
    }
    
}

func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.identifier == rhs.identifier
}
