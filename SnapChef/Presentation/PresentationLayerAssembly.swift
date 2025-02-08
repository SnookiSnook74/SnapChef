//
//  PresentationLayerAssembler.swift
//  SnapChef
//
//  Created by DonHalab on 03.02.2025.
//

final class PresentationLayerAssembly {
    @MainActor
    func registerPresentation(in container: DIContainer) {
        container.register(PhotoTabViewModel.self) {
            guard let getRecipeuseCase = container.resolve(GetRecipeUseCase.self) else {
                fatalError("Не удалось решить зависимость GetRecipeUseCase")
            }
            
            return PhotoTabViewModel(getRecipeUseCase: getRecipeuseCase)
        }
    }
}
