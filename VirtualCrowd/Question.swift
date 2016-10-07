//
//  Question.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

struct Question {
    
    let statement: String
    let notes: String
    let votes: Int
    let id = NSUUID()
    
}
