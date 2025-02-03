//
//  DIContainer.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

import Foundation

final class DIContainer: ObservableObject {
    
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
    
    func registerAllDependencies() {
        ServiceLayerAssembly().registerServices(in: self)
        DataLayerAssembly().registerServices(in: self)
        DomainLayerAssembly().registerServices(in: self)
        PresentationLayerAssembly().registerServices(in: self)
    }
}
