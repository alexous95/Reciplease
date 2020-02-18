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
    
    /// Get all the ingredients associated to the recipe
    /// - Parameter recipe: The recipe which we want the ingredient from
    /// - Returns: An array of ingredient
    static func ingredientsFor(recipe: RecipeBook, managedObjectContext: NSManagedObjectContext) -> [Ingredients] {
        guard let recipeTitle = recipe.title else { return [] }
        
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        
        // We use NSPredicate to retrieve only the ingredient linked to the recipe
        // belongingRecipe is RecipeBook object so we have access to its title
        
        request.predicate = NSPredicate(format: "belongingRecipe.title = %@", recipeTitle)
        request.returnsObjectsAsFaults = false
        
        guard let ingredients = try? managedObjectContext.fetch(request) else { return [] }
        return ingredients
    }
}
