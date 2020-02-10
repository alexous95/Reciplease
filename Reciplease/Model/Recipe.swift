//
//  recipe2.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 04/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

// MARK: - HITS
struct Hits: Codable {
    let q: String?
    let from, to: Int?
    let more: Bool?
    let count: Int?
    let hits: [Hit]?
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?
}

// MARK: - Recipe
struct Recipe: Codable {
    
    let label: String?
    let image: String?
    let ingredientLines: [String]?
    let ingredients: [Ingredient]?
    let calories, totalWeight: Double?
    let totalTime: Int?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String?
    let weight: Double?
}

