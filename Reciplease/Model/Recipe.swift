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
    let uri: String?
    let label: String?
    let image: String?
    let url: String?
    let ingredients: [Ingredient]?
    let totalTime: Double?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String?
    let weight: Double?
}

