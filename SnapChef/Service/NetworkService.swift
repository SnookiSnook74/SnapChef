//
//  NetworkService.swift
//  SnapChef
//
//  Created by DonHalab on 01.02.2025.
//

import Foundation

/// Протокол для сервиса, выполняющего сетевые запросы
protocol NetworkServiceProtocol {
    /// Асинхронный метод получения данных по URLRequest, выбрасывающий только ошибки типа NetworkError
    func fetchData(urlRequest: URLRequest) async throws(NetworkError) -> Data
}

struct NetworkService: NetworkServiceProtocol {
    func fetchData(urlRequest: URLRequest) async throws(NetworkError) -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse(statusCode: -1)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
            }
            return data
        } catch {
            throw NetworkError.underlying(error)
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
