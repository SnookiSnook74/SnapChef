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
    private var requestService = ChatRequestBuilder()
    private let networkService = NetworkService()
    private let jsonDecoder = DecoderService()

    func getRecipe(urlImage: String? = nil) async {
        self.isLoading = true
        self.errorMessage = nil
        self.recipe = nil

        if let urlImage = urlImage, !urlImage.isEmpty {
            requestService = requestService.setImageURL(urlImage)
        }

        guard let request = requestService.buildRequest() else {
            self.isLoading = false
            self.errorMessage = "Ошибка формирования запроса."
            return
        }
        
        do {
            let dataResult = try await networkService.fetchData(urlRequest: request)
            
            if let dataString = String(data: dataResult, encoding: .utf8) {
                print("Полученные данные: \(dataString)")
            } else {
                print("Невозможно преобразовать данные в строку.")
            }
            
            let apiResponse = try jsonDecoder.decode(OpenAIResponse.self, from: dataResult)
            
            if let choice = apiResponse.choices.first, let message = choice.message,
               let content = message.content {
                let recipeData = Data(content.utf8)
                let parsedRecipe = try jsonDecoder.decode(Recipe.self, from: recipeData)
                
                self.recipe = parsedRecipe
                self.isLoading = false
            } else {
                self.errorMessage = "Некорректный ответ от сервера."
                self.isLoading = false
            }
        } catch {
            self.errorMessage = "Ошибка: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
