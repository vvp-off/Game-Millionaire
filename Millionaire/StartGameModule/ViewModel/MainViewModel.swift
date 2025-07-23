import Foundation

struct MoneyForQuestionModel {
    let numberOfQuestions: Int
    let money: Int
}

final class MainViewModel {

    var numberOfQuestions = 0
    var questionNumber = 0
    var score = 0
    var onUpdate: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    private(set) var quiz: [Question] = []

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

    func loadQuestions() {
        NetworkManager().fetchGameQuestions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    let filtered = questions.filter { $0.incorrectAnswers.count == 3 }

                    self?.quiz = filtered.map { original in
                        return Question(
                            type: original.type,
                            difficulty: original.difficulty,
                            category: original.category,
                            question: original.question,
                            correctAnswer: original.correctAnswer,
                            incorrectAnswers: original.incorrectAnswers
                        )
                    }

                    self?.onUpdate?()
                    
                case .failure(let error):
                    print(error)
                    self?.onError?(error)
                }
            }
        }
    }

    func checkAnswer(userAnswer: String?) -> Bool {
        if userAnswer == quiz[questionNumber].correctAnswer {
            return true
        } else {
            return false
        }
    }

    func getQuestionText() -> String {
        guard questionNumber < quiz.count else {
            return "Дождитесь загрузку вопросов"
        }
        return quiz[questionNumber].question
    }

    func getAnswerText(userButtonNumber: Int) -> String {
        guard questionNumber < quiz.count else {
            return ""
        }
        
        let answers = quiz[questionNumber].allAnswers[userButtonNumber]
        return answers
    }

    func getMoneyForQuestion() -> Int {
        if numberOfQuestions < moneyForQuestion.count {
            return moneyForQuestion[numberOfQuestions].money
        } else {
            return 0
        }
    }

    func nextQuestion() {
        if questionNumber < quiz.count - 1 {
            questionNumber += 1
            numberOfQuestions += 1
        } else {
            questionNumber = 0
        }
    }

    func randomQuestion() {
        questionNumber = Int.random(in: 0..<quiz.count)
        numberOfQuestions += 1
    }
}

// MARK: - Подсказки

extension MainViewModel {

    func fiftyPercent() -> [Int] {
        let question = quiz[questionNumber]
        guard let correctIndex = question.allAnswers.firstIndex(of: question.correctAnswer) else {
            return []
        }

        let incorrectIndexes = question.allAnswers.indices.filter { $0 != correctIndex }

        if let randomIncorrectIndex = incorrectIndexes.randomElement() {
            return [correctIndex, randomIncorrectIndex]
        } else {
            return [correctIndex]
        }
    }

    func seventyPercent() -> Int {
        let question = quiz[questionNumber]
        guard let correctIndex = question.allAnswers.firstIndex(of: question.correctAnswer) else {
            return 0
        }
        if Bool.random(probability: 0.7) {
            return correctIndex
        } else {
            let incorrectIndexes = question.allAnswers.indices.filter { $0 != correctIndex }
            return incorrectIndexes.randomElement() ?? correctIndex
        }
    }

    func eightyPercent() -> Int {
        let question = quiz[questionNumber]
        guard let correctIndex = question.allAnswers.firstIndex(of: question.correctAnswer) else {
            return 0
        }
        if Bool.random(probability: 0.8) {
            return correctIndex
        } else {
            let incorrectIndexes = question.allAnswers.indices.filter { $0 != correctIndex }
            return incorrectIndexes.randomElement() ?? correctIndex
        }
    }
}
