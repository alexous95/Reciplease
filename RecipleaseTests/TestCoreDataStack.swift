//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Alexandre Goncalves on 17/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class TestCoreDataStack: CoreDataStack {
    
    convenience init() {
        self.init(modelName: "Reciplease")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        /// Redirects the `NSPersistentStoreCoordinator` to memory.
        ///
        /// Here is all the magic happening. The `NSPersistentStoreCoordinator` is
        /// redirected to memory instead of SQLite.
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(
                    "Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.storeContainer = container
    }
}


