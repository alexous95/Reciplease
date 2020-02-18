//
//  RecipeBook.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

class RecipeBook: NSManagedObject {
    
    /// Returns an array of all the RecipeBook object in core data
    static func all(managedObjectContext: NSManagedObjectContext) -> [RecipeBook] {
        let request: NSFetchRequest<RecipeBook> = RecipeBook.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
}
