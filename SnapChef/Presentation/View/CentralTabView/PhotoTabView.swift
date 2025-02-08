//
//  ContentView.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import SwiftUI
import SwiftData

struct PhotoTabView: View {
    private var viewModel = PhotoTabViewModel()
    // Переменная для выбранного изображения
    @State private var selectedImage: UIImage?
    // Флаг для показа ImagePicker
    @State private var isShowingImagePicker = false

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
                    Text("Нажмите кнопку ниже, чтобы выбрать фото и получить рецепт.")
                        .padding()
                }
                
                Spacer()
                
                // Кнопка для показа ImagePicker
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
                
                // Если фото выбрано, показываем кнопку для получения рецепта
                if let selectedImage = selectedImage {
                    Button {
                        // Преобразуем изображение в Data (например, в JPEG с качеством 0.8)
                        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                            // Получаем строковое представление в формате base64
                            let base64String = imageData.base64EncodedString()
                            let dataUrlString = "data:image/jpeg;base64,\(base64String)"
                            Task {
                                await viewModel.getRecipe(urlImage: dataUrlString)
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
                }
            }
            .navigationTitle("SnapChef")
            // Показываем ImagePicker как модальное окно
            .sheet(isPresented: $isShowingImagePicker) {
                // Используем ваш ImagePicker с sourceType, например, .camera или .photoLibrary
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }
        }
    }
}
