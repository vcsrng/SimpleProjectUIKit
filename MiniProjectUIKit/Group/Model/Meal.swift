//
//  Meal.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import Foundation

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strArea: String
    let strMealThumb: String
    let strInstructions: String
    let strYoutube: String?

    // base on APInya begini, coba di for each ga work entah kenapa T_T
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?

    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?

    // Generate combined ingredients list
    var ingredients: [String] {
        var result: [String] = []
        for i in 1...20 {
            if let ingredient = value(forKey: "strIngredient\(i)")?.trimmingCharacters(in: .whitespacesAndNewlines),
               !ingredient.isEmpty,
               let measure = value(forKey: "strMeasure\(i)")?.trimmingCharacters(in: .whitespacesAndNewlines),
               !measure.isEmpty {
                result.append("\(measure) \(ingredient)")
            }
        }
        return result
    }

    // Helper function for dynamic key access
    private func value(forKey key: String) -> String? {
        return Mirror(reflecting: self).children.first { $0.label == key }?.value as? String
    }
}
