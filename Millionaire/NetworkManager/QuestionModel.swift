//
//  QuestionModel.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 21.07.2025.
//

import Foundation

struct Questions: Codable {
    let response_code: Int
    let results: [Question]
}

struct Question: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    var allAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(String.self, forKey: .type)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        category = try container.decode(String.self, forKey: .category)
        question = try container.decode(String.self, forKey: .question)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)

        var all = [correctAnswer] + incorrectAnswers
        all = Array(NSOrderedSet(array: all)) as! [String]
        allAnswers = all.shuffled()
    }

    init(
        type: String,
        difficulty: String,
        category: String,
        question: String,
        correctAnswer: String,
        incorrectAnswers: [String]
    ) {
        self.type = type
        self.difficulty = difficulty
        self.category = category
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        
        var all = [correctAnswer] + incorrectAnswers
        all = Array(NSOrderedSet(array: all)) as! [String]
        self.allAnswers = all.shuffled()
    }
}
