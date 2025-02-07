//
//  OpenAIResponse.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

// MARK: - Модели для декодирования ответа API

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message?
}

struct Message: Codable {
    let role: String
    let content: String?
    let function_call: FunctionCall?
    let refusal: String?
}

struct FunctionCall: Codable {
    let name: String
    let arguments: String?
}

struct Recipe: Codable, Sendable {
    let title: String
    let ingredients: [String]
    let steps: [String]
    let cooking_time: String
}
