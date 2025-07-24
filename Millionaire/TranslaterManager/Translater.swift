//
//  Translater.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 23.07.2025.
//

import Foundation


class TranslaterManager {
    private let urlString = "https://translate.api.cloud.yandex.net/translate/v2/translate"
#warning("Api key")
    private var apiKey = ""
    private var translatedCharactersCount = UserDefaults.standard.integer(forKey: "translatedCharactersCount")
    
    func translateText(text: [String], completion: @escaping(Result<[TranslateText] ,NetworkError>) -> Void) {
       
        //MARK: Chek translated Characters Count for burn API-Key
        let charactersCount = text.reduce(0) { $0 + $1.count } // all text characters "a" + " " + "!" ...
        print("👀Character count --->>>", charactersCount)
        guard charactersCount < 2000 else { apiKey = ""; print("🔡❌ 2000+ simbols limit / delete api key"); return}
        guard charactersCount < 1500 else { print("🔡❌ 1500+ simbols limit"); return}
        UserDefaults.standard.set(charactersCount + translatedCharactersCount, forKey: "translatedCharactersCount")
        print("🔡 All translated Characters count - \(UserDefaults.standard.integer(forKey: "translatedCharactersCount"))")
        guard translatedCharactersCount < 50000 else { apiKey = ""; print("🔡❌ 50_000 simbols translated / delete api key"); return}
        // end check ;)
        
        let rawValue: TranslaterRequest = TranslaterRequest(texts: text)
        let requestBody = try? JSONEncoder().encode(rawValue)
        
        guard let url = URL(string: urlString) else {print("TRANSLATER -->" ,NetworkError.badURL.rawValue) ;return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Authorization": "Api-Key \(apiKey)"
        ]
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let data else {print("TRANSLATER -->" ,NetworkError.data.rawValue) ;return}
            
            do {
                let translate = try JSONDecoder().decode(TranslaterResponse.self, from: data)
                print(print("✅TRANSLATER Result -->" ,translate.translations))
                completion(.success(translate.translations))
            } catch {
                print(print("❌TRANSLATER -->" ,NetworkError.decode.rawValue))
            }
        }.resume()
    }
}
