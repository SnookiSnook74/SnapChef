//
//  ContentView.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import SwiftUI
import SwiftData

struct CentralTabView: View {
    @State private var viewModel = CentralTabViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Загрузка рецепта...")
                } else if let recipe = viewModel.recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(recipe.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Время приготовления: \(recipe.cooking_time)")
                                .font(.subheadline)
                            
                            Text("Ингредиенты:")
                                .font(.headline)
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                            }
                            
                            Text("Шаги приготовления:")
                                .font(.headline)
                            
                            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                                Text("\(index + 1). \(step)")
                            }
                        }
                        .padding()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Ошибка: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Нажмите кнопку ниже, чтобы получить рецепт.")
                        .padding()
                }
                
                Spacer()
                
                Button {
                    viewModel.fetchRecipe()
                } label: {
                    Text("Получить рецепт")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding([.leading, .trailing, .bottom], 16)
                }
            }
            .navigationTitle("SnapChef")
        }
    }
}
