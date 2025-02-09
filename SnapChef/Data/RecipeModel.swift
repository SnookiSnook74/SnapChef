//
//  Item.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import Foundation
import SwiftData

@Model
final class RecipeModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var ingredients: [String]
    var steps: [String]
    var cookingTime: String

    init(title: String, ingredients: [String], steps: [String], cookingTime: String) {
        self.title = title
        self.ingredients = ingredients
        self.steps = steps
        self.cookingTime = cookingTime
    }

    /// Дополнительный если понадобиться преобразовывать из рецепта
    convenience init(recipe: Recipe) {
        self.init(
            title: recipe.title,
            ingredients: recipe.ingredients,
            steps: recipe.steps,
            cookingTime: recipe.cooking_time
        )
    }
}
