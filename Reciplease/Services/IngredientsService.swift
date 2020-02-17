//
//  IngredientsServices.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 17/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

final class IngredientsService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    /// Creates an ingredients object (object used in core data not the struct one) and a relation to a RecipeBook object
    /// - Parameter ingredient: An ingredient from the recipe (use the Recipe object to get the ingredients)
    /// - Parameter recipeBook: The recipeBook object we want to create a relation to ( Links the ingredient to the recipe)
    func addIngredient(_ ingredient: Ingredient, recipeBook: RecipeBook ) {
        let newIngredient = Ingredients(context: managedObjectContext)
        newIngredient.text = ingredient.text
        newIngredient.weight = ingredient.weight ?? 0.0
        newIngredient.belongingRecipe = recipeBook
        coreDataStack.saveContext()
    }
}
