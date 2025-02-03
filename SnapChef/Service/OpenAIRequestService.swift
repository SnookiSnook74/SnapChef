//
//  RecipeResponse.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

protocol RequestServiceProtocol {
    /// Создание кастомного запроса
    func buildRequest() -> URLRequest?
}

struct OpenAIRequestService: RequestServiceProtocol {

    let apiKey: String
    let model: String
    let maxTokens: Int
    let urlString: String
    let userMessage: String
    let jsonSchema: [String: Any]
    let recipeType: String?
    let imageURL: String?

    init(
        apiKey: String = OpenAI.apiKey,
        model: String = "gpt-4o-mini",
        maxTokens: Int = 1000,
        urlString: String = "https://api.openai.com/v1/chat/completions",
        recipeType: String? = nil,
        userMessage: String? = nil,
        jsonSchema: [String: Any]? = nil,
        imageURL: String? = nil
    ) {
        self.apiKey = apiKey
        self.model = model
        self.maxTokens = maxTokens
        self.urlString = urlString
        self.recipeType = recipeType
        self.imageURL = imageURL
        
        if let userMessage = userMessage {
            self.userMessage = userMessage
        } else if let recipeType = recipeType {
            self.userMessage = "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного \(recipeType)."
        } else {
            self.userMessage = "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного блюда."
        }
        
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
        // Если задан imageURL, формируем content как массив из двух объектов:
        // один с текстом, другой с информацией об изображении.
        // Если imageURL не указан – просто передаём текстовое сообщение.
        let messageContent: Any
        if let imageURL = imageURL {
            messageContent = [
                [
                    "type": "text",
                    "text": userMessage
                ],
                [
                    "type": "image_url",
                    "image_url": [
                        "url": imageURL
                    ]
                ]
            ]
        } else {
            messageContent = userMessage
        }
        
        // Формирование параметров запроса
        let parameters: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": messageContent
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
