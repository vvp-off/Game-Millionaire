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
    static let shared = GameService()
    
    private init() {}
    
    // Вызывается когда данные полностью загружены, после загрузки нужно вызвать startGame
    var onDataLoaded: (() -> Void)?
    
    let moneyForQuestion = [
        MoneyForQuestionModel(numberOfQuestions: 1, money: 500),
        MoneyForQuestionModel(numberOfQuestions: 2, money: 1000),
        MoneyForQuestionModel(numberOfQuestions: 3, money: 2000),
        MoneyForQuestionModel(numberOfQuestions: 4, money: 3000),
        MoneyForQuestionModel(numberOfQuestions: 5, money: 5000),
        MoneyForQuestionModel(numberOfQuestions: 6, money: 7500),
        MoneyForQuestionModel(numberOfQuestions: 7, money: 10000),
        MoneyForQuestionModel(numberOfQuestions: 8, money: 12500),
        MoneyForQuestionModel(numberOfQuestions: 9, money: 15000),
        MoneyForQuestionModel(numberOfQuestions: 10, money: 25000),
        MoneyForQuestionModel(numberOfQuestions: 11, money: 50000),
        MoneyForQuestionModel(numberOfQuestions: 12, money: 100000),
        MoneyForQuestionModel(numberOfQuestions: 13, money: 250000),
        MoneyForQuestionModel(numberOfQuestions: 14, money: 500000),
        MoneyForQuestionModel(numberOfQuestions: 15, money: 1000000)
    ]

    private var questions: [Question] = []
    private var currentQuestionIndex = 0
    private var score = 0

    var fiftyOnFiftyIsOn = true
    var audienceIsOn = true
    var callFriendIsOn = true
    private var mistakeIsOn = false
    private var currentMoney = 0
    
    private var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    private let delay: TimeInterval = 5

    func loadData() {
        if GameStorage.shared.isUnfinishedGame() {
            guard let gameData = GameStorage.shared.loadGameState() else { return }
            questions = gameData.questions
            currentQuestionIndex = gameData.questionIndex
            score = gameData.score
            guard let gameHelp = GameStorage.shared.loadHelpButton() else { return }
            fiftyOnFiftyIsOn = gameHelp.help1
            audienceIsOn = gameHelp.help2
            callFriendIsOn = gameHelp.help3
            self.onDataLoaded?()
        } else {
            NetworkManager().fetchGameQuestions { result in
                switch result {
                case .success(let data):
                    guard !data.isEmpty else {
                        print("Questions is empty")
                        return
                    }
                    self.questions = data
                    DispatchQueue.main.async {
                        GameStorage.shared.saveGameState(index: self.currentQuestionIndex, score: self.score, questions: self.questions)
                        self.onDataLoaded?()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func startGame() {
        guard !questions.isEmpty else { return }
        SoundService.shared.play(sound: .timeTicking)
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
        SoundService.shared.play(sound: .choiseIsMade)

        let isCorrect = selected == currentQuestion.correctAnswer

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if isCorrect {
                SoundService.shared.play(sound: .correctAnswer)
                self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)
                self.currentMoney = self.moneyForQuestion[self.getQuestionNumber() - 1].money
                if self.currentQuestionIndex == 14 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        SoundService.shared.play(sound: .gameWin)
                        GameStorage.shared.clearSavedGame()
                        self.currentMoney = self.moneyForQuestion[self.getQuestionNumber() - 1].money
                        self.delegate?.gameEnd(money: 1000000)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)
                        self.currentMoney = self.moneyForQuestion[self.getQuestionNumber() - 1].money
                    }
                }
            } else if self.mistakeIsOn {
                self.mistakeIsOn = false
                SoundService.shared.play(sound: .wrongAnswer)
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
        GameStorage.shared.saveGameState(index: self.currentQuestionIndex, score: self.score, questions: self.questions)
        SoundService.shared.play(sound: .timeTicking)
        delegate?.showQuestion(question: currentQuestion, questionNumber: currentQuestionIndex + 1)
    }
    
    private func wrongAnswer() {
        SoundService.shared.play(sound: .wrongAnswer)
        GameStorage.shared.clearSavedGame()
        
        let money: Int = {
            switch currentQuestionIndex {
            case 0...5: return 0
            case 6...10: return 5000
            case 11...14: return 25000
            default: return 0
            }
        }()
        self.currentMoney = money
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.gameEnd(money: money)
            SoundService.shared.stop()
        }
    }

    private func showCorrectAnswer() {
        SoundService.shared.play(sound: .correctAnswer)
        GameStorage.shared.saveGameState(index: self.currentQuestionIndex, score: self.score, questions: self.questions)
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
    
    func getCurrentScore() -> String {
        String(score)
    }
    
    func getCurrentMoney() -> String {
        return String(currentMoney)
    }
}

