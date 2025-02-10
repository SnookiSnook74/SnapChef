//
//  ContentView.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import SwiftUI
import SwiftData

struct PhotoTabView: View {
    let viewModel = PhotoTabViewModel()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false

    var body: some View {
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
                    Text("Нажмите кнопку ниже, чтобы выбрать фото и получить рецепт.")
                        .padding()
                }
                
                Spacer()

                Button {
                    isShowingImagePicker = true
                } label: {
                    Text("Выбрать фото")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding([.leading, .trailing])
                }
                Button {
                    guard let selectedImage = selectedImage else {
                        print("Фото не выбрано!")
                        return
                    }
                    if let dataUrlString = selectedImage.openAIConvert() {
                        Task {
                            await viewModel.getRecipe(dataUrlString)
                        }
                    }
                } label: {
                    Text("Получить рецепт")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding([.leading, .trailing, .bottom], 16)
                }
                .disabled(selectedImage == nil)
            }
            .navigationTitle("SnapChef")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }
        }
}
