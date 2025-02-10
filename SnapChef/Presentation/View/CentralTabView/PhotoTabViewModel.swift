//
//  CentralTabViewModel.swift
//  SnapChef
//
//  Created by DonHalab on 05.02.2025.
//

import SwiftUI
import SwiftData

@MainActor
@Observable
final class PhotoTabViewModel {
    var recipe: Recipe?
    var isLoading = false
    var errorMessage: String?
    let getRecipeUseCase: GetRecipeUseCase
    
    init() {
        guard let getRecipeUseCase = DIContainer.shared.resolve(GetRecipeUseCase.self) else {
            fatalError("Не удалось решить зависимость GetRecipeUseCase")
        }
        self.getRecipeUseCase = getRecipeUseCase
    }
    
    func getRecipe(_ urlImage: String) async {
        self.isLoading = true
        self.errorMessage = nil
        self.recipe = nil
        
        do {
            let recipe = try await getRecipeUseCase.execute(
                withImageURL: urlImage,
                description: """
            Ты профессиональный шеф-повар с многолетним опытом. Я буду отправлять тебе фотографии с ингредиентами, и твоя задача — составить максимально подробный рецепт блюда, которое можно из них приготовить. В рецепте укажи название блюда, полный список ингредиентов с точными пропорциями, подробное описание всех этапов приготовления, время и температуру приготовления, а также рекомендации по подаче и украшению. Если на фотографии присутствуют предметы, не являющиеся ингредиентами, добавь в начале сообщения заголовок 'На фото не продукты' и опиши, какие объекты не относятся к еде.
            """)
            self.recipe = recipe
        } catch {
            self.errorMessage = "Ошибка: \(error.localizedDescription)"
        }
        self.isLoading = false
    }
}
