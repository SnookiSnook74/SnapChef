//
//  DomainLayerAssembler.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

final class DomainLayerAssembly {
    func registerDomain(in container: DIContainer) {
        container.register(GetRecipeUseCase.self) {
            guard let networkService = container.resolve(NetworkServiceProtocol.self) else {
                fatalError("Не удалось решить зависимость NetworkServiceProtocol")
            }
            
            guard let decoderService = container.resolve(DecoderServiceProtocol.self) else {
                fatalError("Не удалось решить зависимость DecoderServiceProtocol")
            }

            return GetRecipeUseCase(networkService: networkService, jsonDecoder: decoderService)
        }
    }
}
