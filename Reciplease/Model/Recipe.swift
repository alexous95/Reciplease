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
    let source: String?
    let url: String?
    let shareAs: String?
    let yield: Int?
    let dietLabels, healthLabels, cautions, ingredientLines: [String]?
    let ingredients: [Ingredient]?
    let calories, totalWeight: Double?
    let totalTime: Int?
    let totalNutrients, totalDaily: [String: Total]?
    let digest: [Digest]?
}

// MARK: - Digest
struct Digest: Codable {
    let label, tag: String?
    let schemaOrgTag: String?
    let total: Double?
    let hasRdi: Bool?
    let daily: Double?
    let sub: [Digest]?
    
    enum CodingKeys: String, CodingKey {
        case label, tag, schemaOrgTag, total
        case hasRdi = "hasRDI"
        case daily, sub
    }
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String?
    let weight: Double?
}

// MARK: - Total
struct Total: Codable {
    let label: String?
    let quantity: Double?
}
