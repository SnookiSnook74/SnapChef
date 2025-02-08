//
//  SnapChefApp.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import SwiftUI
import SwiftData

@main
struct SnapChefApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        DIContainer.shared.registerAllDependencies()
    }

    var body: some Scene {
        WindowGroup {
            ContentTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
