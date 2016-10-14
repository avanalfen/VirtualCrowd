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
    let startDate: Date
    let endDate: Date
    let crowdNumber: Int
    
    var fireDate: NSDate? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return nil }
        let fireDateFromThisMorning = NSDate(timeInterval: timeLimit, since: thisMorningAtMidnight as Date)
        return fireDateFromThisMorning
    }
    
    init(title: String, identifier: String, code: String, questions: [Question], timeLimit: TimeInterval, isActive: Bool,  endDate: Date, crowdNumber: Int, startDate: Date) {
        self.title = title
        self.identifier = identifier
        self.code = code
        self.questions = questions
        self.timeLimit = timeLimit
        self.isActive = isActive
        self.endDate = endDate
        self.crowdNumber = crowdNumber
        self.startDate = startDate
    }
}

func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.identifier == rhs.identifier
}
