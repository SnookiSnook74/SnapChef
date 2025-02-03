//
//  RecipeResponse.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

struct ChatRequestBuilder: RequestBuilderServiceProtocol {
    private var apiKey: String = OpenAI.apiKey
    private var model: GptModel = .gpt4oMini
    private var endpoint: String = "https://api.openai.com/v1/chat/completions"
    
    // Параметры для чат-запроса
    private var maxTokens: Int = 1000
    private var recipeType: String?
    private var userMessage: String?
    private var jsonSchema: [String: Any]?
    private var imageURL: String?
    
    // MARK: - Fluent API методы для настройки
    
    func setApiKey(_ apiKey: String) -> Self {
        var copy = self
        copy.apiKey = apiKey
        return copy
    }
    
    func setModel(_ model: GptModel) -> Self {
        var copy = self
        copy.model = model
        return copy
    }
    
    func setMaxTokens(_ maxTokens: Int) -> Self {
        var copy = self
        copy.maxTokens = maxTokens
        return copy
    }
    
    func setRecipeType(_ recipeType: String?) -> Self {
        var copy = self
        copy.recipeType = recipeType
        return copy
    }
    
    func setUserMessage(_ userMessage: String?) -> Self {
        var copy = self
        copy.userMessage = userMessage
        return copy
    }
    
    func setJsonSchema(_ jsonSchema: [String: Any]?) -> Self {
        var copy = self
        copy.jsonSchema = jsonSchema
        return copy
    }
    
    func setImageURL(_ imageURL: String?) -> Self {
        var copy = self
        copy.imageURL = imageURL
        return copy
    }
    
    // MARK: - Построение запроса
    
    func buildRequest() -> URLRequest? {
        let messageContent: Any
        if let imageURL = imageURL {
            messageContent = [
                [
                    "type": "text",
                    "text": resultUserMessage
                ],
                [
                    "type": "image_url",
                    "image_url": [
                        "url": imageURL
                    ]
                ]
            ]
        } else {
            messageContent = resultUserMessage
        }
        
        let parameters: [String: Any] = [
            "model": model.rawValue,
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
                    "schema": resultJsonSchema,
                    "strict": true
                ]
            ],
            "max_tokens": maxTokens
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return nil
        }
        
        guard let url = URL(string: endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        return request
    }
}

// MARK: - Вспомогательные методы
extension ChatRequestBuilder {
    
    private var resultUserMessage: String {
        if let userMessage = userMessage {
            return userMessage
        } else if let recipeType = recipeType {
            return "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного \(recipeType)."
        } else {
            return "Представь, что ты профессиональный шеф-повар. Предложи мне рецепт вкусного блюда."
        }
    }
    
    private var resultJsonSchema: [String: Any] {
        jsonSchema ?? [
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
}
