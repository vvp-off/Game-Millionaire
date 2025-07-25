//
//  Extension+String.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 22.07.2025.
//

import Foundation

// Апишка возвращает строки с html разметкой., расширение исправляет эти строка/поля, что бы вопросы становились блее привленкательными без лишних символов
extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        let decoded = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return decoded?.string ?? self
    }
}
