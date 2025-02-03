//
//  OpenAI.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import Foundation

/// Структура для получения API ключа от OpenAi
struct OpenAI {
    static var apiKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            return key
        } else {
            fatalError("API_KEY is not set in Info.plist.")
        }
    }
}

/// Доступные модели  для текста и голоса
enum GptModel: String {
    case gpt4o = "gpt-4o"
    case gpt4oMini = "gpt-4o-mini"
}
