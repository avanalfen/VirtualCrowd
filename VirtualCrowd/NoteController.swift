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
    
    // MARK: Singleton
    
    static let sharedController = NoteController()
    
    // MARK: Properties
    
    var notes: [Question] = []
    
    // MARK: Functions
    
    func createNote(note: String, question: Question) {
        question.notes = note
        NoteController.sharedController.notes.insert(question, at: 0)
    }
    
}
