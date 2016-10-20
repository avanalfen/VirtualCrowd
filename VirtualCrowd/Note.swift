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
    
    var note: String
    let question: Question?
    
    init(note: String, question: Question?) {
        self.note = note
        self.question = question
    }
}
