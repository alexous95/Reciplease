//
//  DetailFavoriteController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit
import CoreData

class DetailFavoriteController: UIViewController {

    // MARK: - Variables
    
    var recipe: RecipeBook?
    var managedObjectContext: NSManagedObjectContext = AppDelegate.mainContext
    var recipeService: RecipeService?
    
    // MARK: - Outlet
    
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favTitle: UILabel!
    @IBOutlet weak var favIngredients: UITextView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipe()
        setupBackground()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directionFavoriteSegue" {
            let destVC: DirectionsController = segue.destination as! DirectionsController
            guard let recipe = recipe else { return }
            destVC.directions = recipe.url
        }
    }
    
    // MARK: - Private
 
    /// Load information from the recipe
    ///
    /// We fetch our recipes from core data and we use the recipe manager class to get our image from a url
    private func loadRecipe() {
        guard let recipe = recipe else { return }
        guard let imageUrl = recipe.image else { return }
        let ingredients = Ingredients.ingredientsFor(recipe: recipe, managedObjectContext: managedObjectContext)
        favTitle.text = recipe.title
        
        RecipeManager().getImage(from: imageUrl) { (data, success) in
            if success {
                guard let data = data else { return }
                self.favImage.image = UIImage(data: data)
            } else {
                debugPrint("Erreur de chargement de l'image")
            }
        }
        getIngredients(list: ingredients)
    }
    
    /// Fill the text view with our ingredients
    private func getIngredients(list: [Ingredients]) {
        for ingredients in list {
            guard let ingredient = ingredients.text else { return }
            favIngredients.text += "- " + ingredient + "\n"
        }
    }
    
    /// Setup for the background view
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
}
