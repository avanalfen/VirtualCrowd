//
//  Question.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

class Question {
    
    let statement: String
    let notes: String
    let votes: Int
    let session: Session?
    
    init(statement: String, notes: String = "", votes: Int = 0, session: Session?) {
        self.statement = statement
        self.notes = notes
        self.votes = votes
        self.session = session
    }
    
}

