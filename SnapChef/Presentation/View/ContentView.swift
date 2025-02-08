//
//  TabView.swift
//  SnapChef
//
//  Created by DonHalab on 07.02.2025.
//

import SwiftUI

struct ContentView: View {

    init() {
        // Фон
        UITabBar.appearance().backgroundColor = UIColor.black
        // Цвет неактивных элементов
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        // Цвет активного элемента
        UITabBar.appearance().tintColor = UIColor.white
    }

    var body: some View {
        TabView {
            Text("First Tab").tabItem {
                Label("First", systemImage: "star")
            }
            PhotoTabView().tabItem {
                Label("Hello", systemImage: "book")
            }
            Text("Second Tab").tabItem {
                Label("Second", systemImage: "star")
            }
        }
    }
}
