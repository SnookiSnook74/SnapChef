//
//  RequestBuilderServiceProtocol.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

/// Протокол для работы с билдерами запросов к API
protocol RequestBuilderServiceProtocol {
    func buildRequest() -> URLRequest?
}
