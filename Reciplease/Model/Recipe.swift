//
//  Recipe.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 21/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

struct Hits: Codable {
    var query: String?
    var from: Int?
    var to: Int?
    var params: [String:String]?
    var count: Int?
    var more: Bool?
    var hits: [Hit]?
}

struct Hit: Codable {
    var recipe: Recipe?
    var bookmarked: Bool?
    var bought: Bool?
}

struct Recipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var source: String?
    var url: String?
    var yields: Int?
    var calories: Double?
    var totalWeight: Double?
    var ingredients: [Ingredient]?
    var totalNutrients: [NutrientInfo]?
    var totalDaily: [NutrientInfo]?
}

struct Ingredient: Codable {
    var foodId: String?
    var quantity: Double?
    var measure: Measure?
    var weight: Double?
    var food: Food?
}

struct Measure: Codable {
    var uri: String?
    var label: String?
}

struct Food: Codable {
    var foodId: String?
    var label: String?
}

struct NutrientInfo: Codable {
    var uri: String?
    var label: String?
    var quantity: Double?
    var unit: String?
}
