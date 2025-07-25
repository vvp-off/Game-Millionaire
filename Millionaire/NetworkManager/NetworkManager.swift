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
    case decode = "❌Error - JSON decoder error / response"
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
    private let questionCategory = UserDefaults.standard.string(forKey: "questionCategory") //category number
    private let questionType = UserDefaults.standard.string(forKey: "questionType") ?? "multiple" //multiple, boolean

    private func fetchQuestionsByDifficylt(difficulty: String, completion: @escaping(Result<[Question],NetworkError>) -> Void) {
        
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
        print("✅ Current URL -->", url.absoluteString)
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    func fetchGameQuestions(completion: @escaping (Result<[Question], NetworkError>) -> Void) {
        let difficulties = ["easy", "medium", "hard"]
        var allQuestions: [Question] = []
        var fetchError: NetworkError?

        func fetchSequentially(index: Int) {
            guard index < difficulties.count else {
                if let error = fetchError {
                    completion(.failure(error))
                } else {
                    completion(.success(allQuestions))
                    print("✅ All questions -->", allQuestions)
                }
                return
            }

            let currentDifficulty = difficulties[index]

            fetchQuestionsByDifficylt(difficulty: currentDifficulty) { result in
                switch result {
                case .success(let questions):
                    allQuestions.append(contentsOf: questions)
                case .failure(let error):
                    fetchError = error
                    print("❌ \(currentDifficulty):", error.rawValue)
                }

                if index < difficulties.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        fetchSequentially(index: index + 1)
                    }
                } else {
                    fetchSequentially(index: index + 1)
                }
            }
        }
        fetchSequentially(index: 0)
    }
}

