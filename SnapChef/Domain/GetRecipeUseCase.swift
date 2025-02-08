//
//  GetRecipeUseCase.swift
//  SnapChef
//
//  Created by DonHalab on 08.02.2025.
//

import Foundation

final class GetRecipeUseCase: Sendable {
    private let networkService: NetworkServiceProtocol
    private let jsonDecoder: DecoderServiceProtocol
    private let requestBuilder = ChatRequestBuilder()

    init(networkService: NetworkServiceProtocol,
         jsonDecoder: DecoderServiceProtocol
    ) {
        self.networkService = networkService
        self.jsonDecoder = jsonDecoder
    }

    func execute(withImageURL urlImage: String, description: String) async throws -> Recipe {
        let request = requestBuilder
            .setImageURL(urlImage)
            .setMaxTokens(3000)
            .setUserMessage(description)
            .buildRequest()

        guard let request = request else {
            throw NSError(domain: "RequestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка формирования запроса."])
        }

        let dataResult = try await networkService.fetchData(urlRequest: request)

        if let dataString = String(data: dataResult, encoding: .utf8) {
            print("Полученные данные: \(dataString)")
        } else {
            print("Невозможно преобразовать данные в строку.")
        }

        let apiResponse = try jsonDecoder.decode(OpenAIResponse.self, from: dataResult)

        guard let choice = apiResponse.choices.first,
              let message = choice.message,
              let content = message.content else {
            throw NSError(domain: "APIError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Некорректный ответ от сервера."])
        }

        let recipeData = Data(content.utf8)
        let parsedRecipe = try jsonDecoder.decode(Recipe.self, from: recipeData)
        return parsedRecipe
    }
}
