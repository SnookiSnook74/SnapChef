//
//  ContentView.swift
//  SnapChef
//
//  Created by DonHalab on 31.01.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var recipe: Recipe?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Загрузка рецепта...")
                } else if let recipe = recipe {
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
                } else if let errorMessage = errorMessage {
                    Text("Ошибка: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Нажмите кнопку ниже, чтобы получить рецепт.")
                        .padding()
                }
                
                Spacer()
                
                Button(action: fetchRecipe) {
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
    
    func fetchRecipe() {
        isLoading = true
        errorMessage = nil
        recipe = nil

        let requestService = OpenAIRequestService()
        
        guard let request = requestService.buildRequest() else {
            isLoading = false
            errorMessage = "Ошибка формирования запроса."
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { isLoading = false }
            
            if let error = error {
                DispatchQueue.main.async { errorMessage = error.localizedDescription }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { errorMessage = "Нет данных в ответе." }
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                   print("Raw response: \(dataString)")
               }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(OpenAIResponse.self, from: data)
                
                if let choice = apiResponse.choices.first, let message = choice.message {
                    if let content = message.content {
                        // Преобразуем полученный контент в данные для декодирования структуры Recipe
                        let recipeData = Data(content.utf8)
                        let parsedRecipe = try decoder.decode(Recipe.self, from: recipeData)
                        DispatchQueue.main.async { recipe = parsedRecipe }
                    } else if let refusal = message.refusal {
                        DispatchQueue.main.async { errorMessage = refusal }
                    } else {
                        DispatchQueue.main.async { errorMessage = "Неизвестный формат ответа." }
                    }
                } else {
                    DispatchQueue.main.async { errorMessage = "Не удалось получить ответ от модели." }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Ошибка при парсинге ответа: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
