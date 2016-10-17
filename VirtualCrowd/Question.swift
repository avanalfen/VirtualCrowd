//
//  Question.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Question {
    
    let statement: String
    var notes: String
    let session: Session?
    let recordID: CKRecordID
    
    init(statement: String, notes: String = "", session: Session?) {
        self.statement = statement
        self.notes = notes
        self.session = session
    }
}

