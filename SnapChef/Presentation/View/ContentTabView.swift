//
//  TabView.swift
//  SnapChef
//
//  Created by DonHalab on 07.02.2025.
//

import SwiftUI

struct ContentTabView: View {
    
    @State private var selectTab = 1
    private let photoTabViewModel: PhotoTabViewModel

    init() {
        // Фон
        UITabBar.appearance().backgroundColor = UIColor.black
        // Цвет неактивных элементов
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        // Цвет активного элемента
        UITabBar.appearance().tintColor = UIColor.white
        
        guard let viewModel = DIContainer.shared.resolve(PhotoTabViewModel.self) else {
            fatalError("Не удалось разрешить зависимость PhotoTabViewModel")
        }
        photoTabViewModel = viewModel
    }

    var body: some View {
        TabView(selection: $selectTab) {
            Text("First Tab").tabItem {
                Label("First", systemImage: "star")
            }
            .tag(0)
            PhotoTabView(viewModel: photoTabViewModel).tabItem {
                Label("Hello", systemImage: "book")
            }
            .tag(1)
            Text("Second Tab").tabItem {
                Label("Second", systemImage: "star")
            }
            .tag(2)
        }
    }
}
