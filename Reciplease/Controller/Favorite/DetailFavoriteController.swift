//
//  DetailFavoriteController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DetailFavoriteController: UIViewController {

    var recipe: RecipeBook?
    
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favTitle: UILabel!
    @IBOutlet weak var favIngredients: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        guard let recipe = recipe else { return }
        guard let imageUrl = recipe.image else { return }
        let ingredients = Ingredients.ingredientsForRecipe(recipe)
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
    
    private func getIngredients(list: [Ingredients]) {
        for ingredients in list {
            guard let ingredient = ingredients.text else { return }
            favIngredients.text += "- " + ingredient + "\n"
        }
    }
}
