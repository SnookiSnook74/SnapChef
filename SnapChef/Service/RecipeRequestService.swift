//
//  RecipeResponse.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

struct RecipeRequestService {
    
    let urlString: String
    let model: String
    let userMessage: String
    let maxTokens: Int
    let jsonSchema: [String: Any]
    let recipeType: String?
    let apiKey = OpenAI.apiKey

    init(
        urlString: String = "https://api.openai.com/v1/chat/completions",
        model: String = "gpt-4o",
        userMessage: String? = nil,
        maxTokens: Int = 500,
        recipeType: String? = nil,
        jsonSchema: [String: Any]? = nil
    ) {
        self.urlString = urlString
        self.model = model
        self.recipeType = recipeType
        
        if let userMessage = userMessage {
            self.userMessage = userMessage
        } else if let recipeType = recipeType {
            self.userMessage = "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного \(recipeType)."
        } else {
            self.userMessage = "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного блюда."
        }
        
        self.maxTokens = maxTokens
        self.jsonSchema = jsonSchema ?? [
            "type": "object",
            "properties": [
                "title": [
                    "type": "string",
                    "description": "Название рецепта."
                ],
                "ingredients": [
                    "type": "array",
                    "description": "Список ингредиентов.",
                    "items": [
                        "type": "string"
                    ]
                ],
                "steps": [
                    "type": "array",
                    "description": "Шаги приготовления.",
                    "items": [
                        "type": "string"
                    ]
                ],
                "cooking_time": [
                    "type": "string",
                    "description": "Время приготовления."
                ]
            ],
            "required": ["title", "ingredients", "steps", "cooking_time"],
            "additionalProperties": false
        ]
    }
    
    /// Функция для формирования URLRequest
    func buildRequest() -> URLRequest? {
        // Формирование параметров запроса
        let parameters: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": userMessage
                ]
            ],
            "response_format": [
                "type": "json_schema",
                "json_schema": [
                    "name": "recipe",
                    "schema": jsonSchema,
                    "strict": true
                ]
            ],
            "max_tokens": maxTokens
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return nil
        }

        guard let url = URL(string: urlString) else { return nil }
        
        // Формирование URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        return request
    }
}
