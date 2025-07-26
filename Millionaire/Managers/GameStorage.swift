//
//  GameStorage.swift
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

struct GameSaveDataHelp: Codable {
    let help1: Bool
    let help2: Bool
    let help3: Bool
}

final class GameStorage {
    private let unfinishedGameKey = "unfinishedGame"
    private let bestScoreKey = "bestScore"
    private let saveButtonKey = "saveButtonKey"
    
    static let shared = GameStorage()
    
    private init() {}
    
    // MARK: - Сохранение текущей игры
    func saveGameState(index: Int, score: Int, questions: [Question]) {
        print("Сохранение игры")
        let saveData = GameSaveData(questionIndex: index, score: score, questions: questions)
        if let encoded = try? JSONEncoder().encode(saveData) {
            UserDefaults.standard.set(encoded, forKey: unfinishedGameKey)
        }
        saveBestScore(score)
    }
    
    // MARK: - Загрузка игры
    func loadGameState() -> GameSaveData? {
        print("Загрузка игры")
        guard let data = UserDefaults.standard.data(forKey: unfinishedGameKey),
              let decoded = try? JSONDecoder().decode(GameSaveData.self, from: data) else {
            return nil
        }
        print(decoded.questionIndex, decoded.questions[0], decoded.score)
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
    
    func saveHelpButton(help1: Bool, help2: Bool, help3: Bool)  {
        let saveData = GameSaveDataHelp(help1: help1, help2: help2, help3: help3)
        if let encoded = try? JSONEncoder().encode(saveData) {
            UserDefaults.standard.set(encoded, forKey: saveButtonKey)
        }
    }
    
    func loadHelpButton() -> GameSaveDataHelp? {
        guard let data = UserDefaults.standard.data(forKey: saveButtonKey),
              let decoded = try? JSONDecoder().decode(GameSaveDataHelp.self, from: data) else {
            return nil
        }
        print(decoded.help1, decoded.help2, decoded.help3)
        return decoded
    }
}
