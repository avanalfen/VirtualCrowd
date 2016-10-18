//
//  Note.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/18/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CloudKit

class Note {
    
    static let kNote = "noteKey"
    static let kReference = "referenceKey"
    static let recordType = "Note"
    
    var note: String
    
    init(note: String) {
        self.note = note
    }
    
    convenience init?(record: CKRecord) {
        guard let note = record[Note.kNote] as? String else { return nil }
        self.init(note: note)
    }
    
}
