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

class GameService {
    weak var delegate: GameDelegate?
    var onDataLoaded: (() -> Void)? // Вызывается когда данные полностью загружены, после загрузки нужно вызвать startGame
    
    private let soundService = SoundService()
    private let dataManager = DataManager()
    
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
    
    private func loadData() {
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
    
    func selectAnswer(_ selected: String) {
        soundService.play(sound: .choiseIsMade)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            
            if selected == self.currentQuestion.correctAnswer {
                self.soundService.play(sound: .correctAnswer)
                self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer)
                
                if self.currentQuestionIndex == 14 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.soundService.play(sound: .gameWin)
                        self.delegate?.gameEnd(money: 1000000)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.delegate?.selectCurrentAnswer(correctAnswer: self.currentQuestion.correctAnswer, )
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
    
    func nextQuestion() {
        currentQuestionIndex += 1
        soundService.play(sound: .timeTicking)
        delegate?.showQuestion(question: currentQuestion, questionNumber: currentQuestionIndex + 1)
    }
    
    private func showCorrectAnswer() {
        soundService.play(sound: .correctAnswer)
        delegate?.selectCurrentAnswer(correctAnswer: currentQuestion.correctAnswer)
    }
    
    func getQuestionNumber() -> Int {
        currentQuestionIndex + 1
    }
}

extension GameService {
    func fiftyOnFiftyIsOnTapped() {
        guard !fiftyOnFiftyIsOn else { return }
        fiftyOnFiftyIsOn = true
        
        let incorrectAnswers = currentQuestion.incorrectAnswers.shuffled()
        guard incorrectAnswers.count >= 2 else { return }
        
        let wrong1 = incorrectAnswers[0]
        let wrong2 = incorrectAnswers[1]
        
        delegate?.didUseFiftyOnFifty(wrongAnswer1: wrong1, wrongAnswer2: wrong2)
    }
    
    func audienceIsOnTapped() {
        guard !audienceIsOn else { return }
        audienceIsOn = true
        
        let correctAnswer = currentQuestion.correctAnswer
        let incorresctAnswers = currentQuestion.incorrectAnswers
        
        
        let correctShouldBeTop = Int.random(in: 0..<100) < 70
        let correctPercentage = correctShouldBeTop ? Int.random(in: 55...75) : Int.random(in: 10...40)
        
        let remainsPercentage = 100 - correctPercentage
        
        let wrong1 = Int.random(in: 5...(remainsPercentage - 10))
        let wrong2 = Int.random(in: 1...(remainsPercentage - wrong1 - 5))
        let wrong3 = remainsPercentage - wrong1 - wrong2
        
        let wrongs = [wrong1, wrong2, wrong3].shuffled()
        
        var result: [String: Int] = [:]
        for (index, answer) in incorresctAnswers.enumerated() {
            result[answer] = wrongs[index]
        }
        
        result[correctAnswer] = correctPercentage
        
        delegate?.didUseAudience(result: result)
    }
    
    func mistakeIsOnTapped() {
        guard !mistakeIsOn else { return }
        mistakeIsOn = true
        delegate?.didUseMistake()
    }
}

