//
//  VoteController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/17/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class VoteController {
    
    static let sharedController = VoteController()
    
    func createVoteRecordWith(question: Question, vote: Vote) {
        
        guard let identifier = question.recordID else { return }
        
        let kReference = "referenceKey"
        
        let cloudKitManager = CloudKitManager()
        
        let recordNameID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: recordNameID)
        
        let record = CKRecord(recordType: "Vote", recordID: recordID)
        let reference = CKReference(recordID: identifier, action: .deleteSelf)
        
        record.setObject(vote.vote as CKRecordValue?, forKey: Vote.kVote)
        record.setObject(reference, forKey: kReference)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("VoteController.createRecordWith.saveRecord. \n \(error?.localizedDescription)")
            }
        }
    }
}
