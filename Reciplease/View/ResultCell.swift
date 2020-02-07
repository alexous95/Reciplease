//
//  ResultCell.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 06/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    
    func configure(title: String, ingredients: [Ingredient], image: String){
        var ingredientArray = [String]()
        
        for ingredient in ingredients {
            ingredientArray.append(ingredient.text ?? "")
        }
        
        activityWheel.isHidden = false
        activityWheel.startAnimating()
        
        RecipeManager().getImage(from: image) { (data, success) in
            if success {
                guard let data = data else { return }
                self.recipeImage.image = UIImage(data: data)
                self.activityWheel.stopAnimating()
                self.activityWheel.isHidden = true
            }
        }
        recipeTitle.text = title
        recipeIngredients.text = ingredientArray.joined(separator: ",")
    }
}
