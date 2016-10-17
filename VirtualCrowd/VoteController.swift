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
    
    func createRecordWith(question: Question) -> CKRecordID {
        
        let kReference = "referenceKey"
        
        let cloudKitManager = CloudKitManager()
        
        let recordNameID = UUID().uuidString
        
        let recordID = CKRecordID(recordName: recordNameID)
        
        let record = CKRecord(recordType: "Vote", recordID: recordID)
        let reference = CKReference(recordID: question.recordID, action: .deleteSelf)
        
        record.setObject(reference, forKey: kReference)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("VoteController.createRecordWith.saveRecord. /n \(error?.localizedDescription)")
            }
        }
        return recordID
    }
}
