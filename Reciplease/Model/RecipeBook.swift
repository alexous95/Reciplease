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
    static var all: [RecipeBook] {
        let request: NSFetchRequest<RecipeBook> = RecipeBook.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipes
    }
}
