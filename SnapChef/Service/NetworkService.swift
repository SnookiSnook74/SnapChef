//
//  NetworkService.swift
//  SnapChef
//
//  Created by DonHalab on 01.02.2025.
//

import Foundation

/// Протокол для сервиса, выполняющего сетевые запросы
protocol NetworkServiceProtocol: Sendable {
    /// Асинхронный метод получения данных по URLRequest, выбрасывающий только ошибки типа NetworkError
    func fetchData(urlRequest: URLRequest) async throws(NetworkError) -> Data
}

struct NetworkService: NetworkServiceProtocol {
    
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(urlRequest: URLRequest) async throws(NetworkError) -> Data {
        let maxRetries: Int = 3
        var currentAttempt = 1
        
        while true {
            do {
                let (data, response) = try await session.data(for: urlRequest)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: -1)
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
                
                return data
                
            } catch {
                if currentAttempt >= maxRetries {
                    throw NetworkError.underlying(error)
                }
                currentAttempt += 1
            }
        }
    }
}

/// Тип ошибок, возникающих при выполнении сетевых запросов
enum NetworkError: Error {
    /// Некорректный HTTP-ответ с указанным кодом статуса
    case badResponse(statusCode: Int)
    /// Любая другая ошибка, возникшая во время выполнения запроса
    case underlying(Error)
}
