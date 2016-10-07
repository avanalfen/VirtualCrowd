//
//  Session.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

struct Session {
    
    let title: String
    let id: UUID
    let code: String
    let questions: [Question]?
    let timeLimit: TimeInterval
    let isActive: Bool
    let date: Date
    let crowdNumber: Int
    
}
