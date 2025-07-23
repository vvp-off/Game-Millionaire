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

    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
