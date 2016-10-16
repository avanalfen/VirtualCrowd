//
//  CoreDataStack.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/15/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VirtualCrowd")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error {
                fatalError("Error loading persistant store: \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
}
