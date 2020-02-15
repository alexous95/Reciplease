//
//  DatabaseManager.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 14/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    //private init() {}
    
    // MARK: - Database Level Properties
    
    /// Managed Context for Core Data
    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Persistent Container for our Core Data stack.
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Saves or Updates the given instance to the database.
    ///
    /// If you retrieved a class instance from this class and you edit it's
    /// attributes and then used this function, then this method will perform
    /// update.
    ///
    /// If you however, requested an empty class instance from this class and you
    /// added data to it's attributes, then this method will perform insertion.
    ///
    /// - Attributes:
    ///     - instance: The instance to be added/updated.
    ///
    /// - Returns: True if the operation was successful, false otherwise.
    func saveOrUpdate(instance: NSManagedObject) -> Bool {
        do {
            try instance.managedObjectContext?.save()
            return true
        } catch {
            fatalError("Failed: \(error)")
        }
        return false
    }
}
