//
//  DIContainer.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

final class DIContainer {
    
    nonisolated(unsafe) static let shared = DIContainer()
    
    private init() {}
    
    private var factories = [String: () -> Any]()

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return factories[key]?() as? T
    }
}

extension DIContainer {
    
    @MainActor
    func registerAllDependencies() {
        ServiceLayerAssembly().registerServices(in: self)
        DataLayerAssembly().registerData(in: self)
        DomainLayerAssembly().registerDomain(in: self)
        PresentationLayerAssembly().registerPresentation(in: self)
    }
}
