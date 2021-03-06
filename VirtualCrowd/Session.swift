//
//  Session.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Session: Equatable {
    
    static let kStart = "startKey"
    static let kEnd = "endKey"
    static let kIdentifier = "identifierKey"
    static let kCode = "codeKey"
    static let kActive = "isActiveKey"
    static let kUser = "userKey"
    static let kTitle = "titleKey"
    static let kTimeLimit = "timeLimitKey"
    static let kCrowdNumber = "crowdNumberKey"
    static let kReference = "referenceKey"
    
    static let recordType = "Session"
    
    let title: String
    let identifier: String
    let code: String
    let timeLimit: TimeInterval
    var isActive: Bool
    let startDate: Date
    let endDate: Date
    let crowdNumber: Int
    let recordID: CKRecordID
    
    init(title: String, identifier: String, code: String, timeLimit: TimeInterval, isActive: Bool,  endDate: Date, crowdNumber: Int, startDate: Date, recordID: CKRecordID) {
        self.title = title
        self.identifier = identifier
        self.code = code
        self.timeLimit = timeLimit
        self.isActive = isActive
        self.endDate = endDate
        self.crowdNumber = crowdNumber
        self.startDate = startDate
        self.recordID = recordID
    }
    
    convenience init?(record: CKRecord) {
        guard let title = record[Session.kTitle] as? String,
            let identifier = record[Session.kIdentifier] as? String,
            let code = record[Session.kCode] as? String,
            let timeLimit = record[Session.kTimeLimit] as? TimeInterval,
            let isActive = record[Session.kActive] as? Bool,
            let recordID = record[Session.kReference] as? CKReference,
            let startDate = record[Session.kStart] as? Date,
            let endDate = record[Session.kEnd] as? Date,
            let crowdNumber = record[Session.kCrowdNumber] as? Int
            else { return nil }
        self.init(title: title, identifier: identifier, code: code, timeLimit: timeLimit, isActive: isActive, endDate: endDate, crowdNumber: crowdNumber, startDate: startDate, recordID: recordID.recordID)
    }
}

func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.identifier == rhs.identifier
}
