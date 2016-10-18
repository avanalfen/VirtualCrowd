//
//  NoteController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/18/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class NoteController {
    
    static let sharedController = NoteController()
    
    func createNoteRecordFor(question: Question, note: Note) {
        guard let questionID = question.recordID else { return }
        
        let cloudKitManager = CloudKitManager()
        
        let id = UUID().uuidString
        
        let recordID = CKRecordID(recordName: id)
        
        let reference = CKReference(recordID: questionID, action: .deleteSelf)
        
        let record = CKRecord(recordType: "Note", recordID: recordID)
        record.setObject(note.note as CKRecordValue?, forKey: Note.kNote)
        record.setObject(reference, forKey: Note.kReference)
        
        cloudKitManager.saveRecord(record) { (record, error) in
            if error != nil {
                print("NoteController.createNoteRecordFor.saveRecord.\n \(error?.localizedDescription)")
            }
        }
    }
}
