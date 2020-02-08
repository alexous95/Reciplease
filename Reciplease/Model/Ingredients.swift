//
//  Ingredients.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

class Ingredients: NSManagedObject {
    
    static func ingredientsForRecipe(_ recipe: RecipeBook) -> [Ingredients] {
        guard let recipeTitle = recipe.title else { return [] }
        
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        request.predicate = NSPredicate(format: "belongingRecipe.title = %@", recipeTitle)
        request.returnsObjectsAsFaults = false
        
        guard let ingredients = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return ingredients
    }
}
