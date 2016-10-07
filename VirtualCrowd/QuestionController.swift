//
//  QuestionController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

class QuestionController {
    
    static let sharedController = QuestionController()
    
    var questionPool: [Question] = []
    
    func createQuestion(statement: String) {
        
        let newQuestion = Question(statement: "Can you explain that a little more?", notes: "", votes: 0)
        
        questionPool.append(newQuestion)
    }
}
