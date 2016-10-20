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
    
    var notes: [Note] = []
    
    // MARK: Functions
    
    func createNote(note: String, question: Question) {
        let newNote = Note(note: note, question: question)
        self.notes.insert(newNote, at: 0)
    }
    
}
