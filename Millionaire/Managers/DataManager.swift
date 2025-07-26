//
//  DataManager.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import Foundation


struct GameSaveData: Codable {
    let questionIndex: Int
    let score: Int
    let questions: [Question]
}

final class GameStorage {
    private let unfinishedGameKey = "unfinishedGame"
    private let bestScoreKey = "bestScore"
    
    static let shared = GameStorage()
    
    private init() {}
    
    // MARK: - Сохранение текущей игры
    func saveGameState(index: Int, score: Int, questions: [Question]) {
        let saveData = GameSaveData(questionIndex: index, score: score, questions: questions)
        if let encoded = try? JSONEncoder().encode(saveData) {
            UserDefaults.standard.set(encoded, forKey: unfinishedGameKey)
        }
    }
    
    // MARK: - Загрузка игры
    func loadGameState() -> GameSaveData? {
        guard let data = UserDefaults.standard.data(forKey: unfinishedGameKey),
              let decoded = try? JSONDecoder().decode(GameSaveData.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    // MARK: - Удаление сохранения
    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: unfinishedGameKey)
    }
    
    // MARK: - Проверка наличия сохранённой игры
    func isUnfinishedGame() -> Bool {
        return UserDefaults.standard.data(forKey: unfinishedGameKey) != nil
    }
    
    // MARK: - Сохранение и проверка рекорда
    func saveBestScore(_ score: Int) {
        let current = UserDefaults.standard.integer(forKey: bestScoreKey)
        if score > current {
            UserDefaults.standard.set(score, forKey: bestScoreKey)
        }
    }

    func isBestScore() -> Bool {
        return UserDefaults.standard.integer(forKey: bestScoreKey) > 0
    }

    func getBestScore() -> String {
        return String(UserDefaults.standard.integer(forKey: bestScoreKey))
    }
}
