//
//  UIImageExtension.swift
//  SnapChef
//
//  Created by DonHalab on 09.02.2025.
//

import UIKit

extension UIImage {
    /// Преобразует изображение в строку data URL формата JPEG.
    /// - Parameter compressionQuality: качество сжатия JPEG (по умолчанию 0.8).
    /// - Returns: Строка data URL, если удалось получить данные изображения, иначе `nil`.
    func openAIConvert(compressionQuality: CGFloat = 0.8) -> String? {
        guard let imageData = self.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        let base64String = imageData.base64EncodedString()
        return "data:image/jpeg;base64,\(base64String)"
    }
}
