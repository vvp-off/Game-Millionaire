//
//  NetworkManager.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 21.07.2025.
//

import Foundation

enum NetworkError: String, Error {
    case badURL = "❌Error - bad URL"
    case sessionError = "❌Error - URLSession"
    case data = "❌Error - no data"
    case decode = "❌Error - JSON decoder error"
}

enum QuestionCategory: String {
    case nature = "17"
    case computers = "18"
    case sports = "21"
    case vehicles = "28"
}

class NetworkManager {
    
    private let scheme = "https"
    private let host = "opentdb.com"
    private let pathComponent = "/api.php"
    
    private let questionCount = "5"
    private var difficulties = ["easy", "medium", "hard"]
    private let questionCategory = UserDefaults.standard.string(forKey: "questionCategory") //category number
    private let questionType = UserDefaults.standard.string(forKey: "questionType") ?? "multiple" //multiple boolean

    func fetchQuestions(difficulty: String, completion: @escaping(Result<[Question],NetworkError>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = pathComponent
        
        var queryItems = [URLQueryItem(name: "amount", value: questionCount),
                          URLQueryItem(name: "difficulty", value: difficulty),
                          URLQueryItem(name: "type", value: questionType)]
        
        if questionCategory != nil {
            queryItems.append(URLQueryItem(name: "category", value: questionCategory))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { completion(.failure(.badURL)); return}
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else { completion(.failure(.sessionError)); return}
            guard let data = data else { completion(.failure(.data)); return}
            
            do {
                let questions = try JSONDecoder().decode(Questions.self, from: data)
                print("✅ \(difficulty) questions --- >>", questions.results)
                completion(.success(questions.results)) // array of questions
            } catch {
                completion(.failure(.decode))
            }
        }.resume()
    }
    
    func fetchGameQuestions(completion: @escaping(Result<[Question], NetworkError>) -> Void) {
        var gameQuestions: [Question] = []
        var fetchError: NetworkError?
        let group = DispatchGroup()
        
        for level in difficulties {
            group.enter()
            fetchQuestions(difficulty: level) { result in
                switch result {
                case .success(let questions):
                    gameQuestions += questions
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(.sessionError))
            } else {
                completion(.success(gameQuestions))
                print(print("✅ All questions -->", gameQuestions))
            }
        }
        
    }
}

