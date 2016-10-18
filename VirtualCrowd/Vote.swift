//
//  Vote.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/17/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Vote {
    
    static let recordType = "Vote"
    static let kVote = "voteKey"
    
    let vote: Bool
    
    init(vote: Bool) {
        self.vote = vote
    }
    
    convenience init?(record: CKRecord) {
        guard let vote = record[Vote.kVote] as? Bool else { return nil }
        self.init(vote: vote)
    }
    
}
