//
//  TranslaterRequest.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 23.07.2025.
//

import Foundation

struct TranslaterRequest: Encodable {
    let sourceLanguageCode: String = "en"
    let targetLanguageCode: String = "ru"
    let format: String = "PLAIN_TEXT"
    let texts: [String]
    let folderId: String = "b1gtben7nisn71ek59d9"
    let speller: Bool = true
}

//    {
//      "sourceLanguageCode": "string",
//      "targetLanguageCode": "string",
//      "format": "string",
//      "texts": [
//        "string"
//      ],
//      "folderId": "string",
//      "model": "string",
//      "glossaryConfig": {
//        // Includes only one of the fields `glossaryData`
//        "glossaryData": {
//          "glossaryPairs": [
//            {
//              "sourceText": "string",
//              "translatedText": "string",
//              "exact": "boolean"
//            }
//          ]
//        }
//        // end of the list of possible fields
//      },
//      "speller": "boolean"
//    }

