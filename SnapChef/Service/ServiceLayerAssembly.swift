//
//  ServiceLayerAssembly.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

/// Сборщик зависимостей сервисного слоя
final class ServiceLayerAssembly {
    
    func registerServices(in container: DIContainer) {
        container.register(NetworkServiceProtocol.self) {
            NetworkService()
        }
        
        container.register(DecoderServiceProtocol.self) {
            DecoderService()
        }
    }
}
