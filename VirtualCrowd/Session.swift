//
//  Session.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

struct Session: Equatable {
    
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
}

func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.identifier == rhs.identifier
}
