//
//  GameService.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import Foundation

protocol GameDelegate: AnyObject {
    func showQuestion(question: Question, questionNumber: Int) // Показывает новый вопрос и его номер
    func selectCurrentAnswer(correctAnswer: String) // Подсвечивает правильный ответ
    func gameEnd(money: Int) // Завершает игру и передаёт сумму выигрыша
    
    func didUseFiftyOnFifty(wrongAnswer1: String, wrongAnswer2: String) // Активирует подсказку 50/50
    func didUseAudience(result: [String : Int]) // Активирует подсказку "Помощь зала" — отображает проценты по каждому варианту
    func didUseMistake() // Активирует подсказку "Вторая попытка" — неправильный ответ не завершает игру
    func secondLifeWorked(wrongAnswer: String) // Сработала "Вторая попытка" нужно закрасить неправильный ответ
}

final class GameService {

    weak var delegate: GameDelegate?
    // Вызывается когда данные полностью загружены, после загрузки нужно вызвать startGame
    var onDataLoaded: (() -> Void)?

    private let soundService = SoundService()

    private var currentQuestionIndex = 0
    private var questions: [Question] = []

    private var fiftyOnFiftyIsOn = false
    private var audienceIsOn = false
    private var mistakeIsOn = false
    
    private var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    private let delay: TimeInterval = 5
    
    init() {
        loadData()
    }

    func loadData() {
        NetworkManager().fetchGameQuestions { result in
            switch result {
            case .success(let data):
                guard !data.isEmpty else {
                    print("Questions is empty")
                    return
                }
                self.questions = data
                DispatchQueue.main.async {
                    self.onDataLoaded?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func startGame() {
        guard !questions.isEmpty else { return }
        currentQuestionIndex = 0
        soundService.play(sound: .timeTicking)
        delegate?.showQuestion(question: questions[currentQuestionIndex], questionNumber: currentQuestionIndex + 1)
        
    }

    func getQuestionNumber() -> Int {
        currentQuestionIndex + 1
    }

    func getCurrentQuestion() -> Question? {
        guard !questions.isEmpty else { return nil }
        return questions[currentQuestionIndex]
    }

    func selectAnswer(_ selected: String) -> Bool {
        soundService.play(sound: .choiseIsMade)

        let isCorrect = selected == currentQuestion.correctAnswer

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isCorrect {
                self.soundService.play(sound: .correctAnswer)
                self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)
                
                if self.currentQuestionIndex == 14 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.soundService.play(sound: .gameWin)
                        self.delegate?.gameEnd(money: 1000000)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)

                    }
                }
            } else if self.mistakeIsOn {
                self.mistakeIsOn = false
                self.soundService.play(sound: .wrongAnswer)
                self.delegate?.secondLifeWorked(wrongAnswer: selected)
            } else {
                self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)
                self.wrongAnswer()
            }
        }

        return isCorrect
    }

    func nextQuestion() {
        currentQuestionIndex += 1
        soundService.play(sound: .timeTicking)
        delegate?.showQuestion(question: currentQuestion, questionNumber: currentQuestionIndex + 1)
    }
    
    private func wrongAnswer() {
        soundService.play(sound: .wrongAnswer)

        let money: Int = {
            switch currentQuestionIndex {
            case 0...5: return 0
            case 6...10: return 5000
            case 11...14: return 25000
            default: return 0
            }
        }()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.delegate?.gameEnd(money: money)
            self.soundService.stop()
        }
    }

    private func showCorrectAnswer() {
        soundService.play(sound: .correctAnswer)
        delegate?.selectCurrentAnswer(correctAnswer: currentQuestion.correctAnswer)
    }
}

// MARK: - Hints

extension GameService {
    
    func getFiftyOnFiftyAnswerIndexes() -> [Int] {
        guard let correctIndex = currentQuestion.allAnswers.firstIndex(of: currentQuestion.correctAnswer) else {
            return []
        }

        let incorrectIndexes = currentQuestion.allAnswers.indices.filter { $0 != correctIndex }

        if let randomIncorrectIndex = incorrectIndexes.randomElement() {
            return [correctIndex, randomIncorrectIndex]
        } else {
            return [correctIndex]
        }
    }

    func audienceDistribution() -> [Int: Int] {
        guard let correctIndex = currentQuestion.allAnswers.firstIndex(of: currentQuestion.correctAnswer) else {
            return [:]
        }

        let correctPercent = 70
        let remainingPercent = 100 - correctPercent

        let incorrectIndexes = currentQuestion.allAnswers.indices.filter { $0 != correctIndex }

        let wrong1 = Int.random(in: 5...(remainingPercent - 10))
        let wrong2 = Int.random(in: 1...(remainingPercent - wrong1 - 5))
        let wrong3 = remainingPercent - wrong1 - wrong2

        let wrongPercents = [wrong1, wrong2, wrong3].shuffled()

        var distribution: [Int: Int] = [:]
        distribution[correctIndex] = correctPercent

        for (idx, wrongIndex) in incorrectIndexes.enumerated() {
            distribution[wrongIndex] = wrongPercents[idx]
        }

        return distribution
    }

    func callFriend() -> String {
        guard let correctIndex = currentQuestion.allAnswers.firstIndex(of: currentQuestion.correctAnswer) else {
            return "Извини, я не уверен в ответе "
        }

        let selectedIndex: Int
        if Bool.random(probability: 0.8) {
            selectedIndex = correctIndex
        } else {
            let incorrectIndexes = currentQuestion.allAnswers.indices.filter { $0 != correctIndex }
            selectedIndex = incorrectIndexes.randomElement() ?? correctIndex
        }

        let letter = ["A", "B", "C", "D"][selectedIndex]
        return "🧑‍💼 Я думаю, правильный ответ — \(letter)"
    }
    
    func isUnfinishedGame() -> Bool {
        GameStorage.shared.isUnfinishedGame()
        
    }
    
    func isBestScore() -> Bool {
        GameStorage.shared.isBestScore()
    }
    
    func getBestScoreValue() -> String {
        String(GameStorage.shared.getBestScore())
    }
}

