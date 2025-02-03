//
//  ImageRequestBuilder.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

struct ImageRequestBuilder: RequestBuilderServiceProtocol {
    private var apiKey: String = OpenAI.apiKey
    private var model: String = "dall-e-3"
    private var endpoint: String = "https://api.openai.com/v1/images/generations"
    
    // Параметры для генерации изображений
    private var prompt: String?
    private var imageCount: Int = 1
    private var imageSize: String = "1024x1024"
    
    // MARK: - Fluent API методы для настройки
    
    func setApiKey(_ apiKey: String) -> Self {
        var copy = self
        copy.apiKey = apiKey
        return copy
    }
    
    func setModel(_ model: String) -> Self {
        var copy = self
        copy.model = model
        return copy
    }
    
    func setPrompt(_ prompt: String) -> Self {
        var copy = self
        copy.prompt = prompt
        return copy
    }
    
    func setImageCount(_ count: Int) -> Self {
        var copy = self
        copy.imageCount = count
        return copy
    }
    
    func setImageSize(_ size: String) -> Self {
        var copy = self
        copy.imageSize = size
        return copy
    }
    
    // MARK: - Построение запроса
    
    func buildRequest() -> URLRequest? {
        guard let prompt = prompt else {
            print("Prompt не задан для генерации изображения")
            return nil
        }
        
        let parameters: [String: Any] = [
            "model": model,
            "prompt": prompt,
            "n": imageCount,
            "size": imageSize
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
