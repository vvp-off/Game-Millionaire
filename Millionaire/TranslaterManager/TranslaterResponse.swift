//
//  TranslaterResponse.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 23.07.2025.
//

import Foundation

struct TranslaterResponse: Decodable {
    let translations: [TranslateText]
}

struct TranslateText: Decodable {
    let text: String
    // let detectedLanguageCode: String
}


// Code 200 - OK
// 401 - authError
//{
//  "translations": [
//    {
//      "text": "string",
//      "detectedLanguageCode": "string"
//    }
//  ]
//}
