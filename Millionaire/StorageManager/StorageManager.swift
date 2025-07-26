//
//  StorageManager.swift
//  Millionaire
//
//  Created by Marat Fakhrizhanov on 23.07.2025.
//

import Foundation

class StorageManager {
    private let networManager = NetworkManager()
    private let translateManager = TranslaterManager()
    var translationEnabled = UserDefaults.standard.string(forKey: "translationEnabled") ?? "off"
    // Добавить переключатель выбранного языка и если он включен "on", то перевести текущие вопросы и в дальнейшем переводить новые
    // иначе поставить на "off"
    // каждый запрос платный с привязанной карты
    
    var gameQuestions: [Question] = [] // UD
    var translatedGameQuestions: [Question] = []
    
    func translateGameQuestions(englishQuestions: [Question]) {
    // Вызвать отдельно ф-ию если юзер переключил язык во время текущей игры для перевода текущих вопросов (экономить запросы и деньги за каждый запрос не вызывая перевод при ангоязычных вопросах)
        
        let group = DispatchGroup()
        
        var correctAnswers: [String] = []
        var incorrectAnswers: [String] = []
        var questions: [String] = []
        var incorrectAnswersGroups: [[String]] = []
        
        for question in englishQuestions {
            questions.append(question.question)
            correctAnswers.append(question.correctAnswer)
            for incorrectAnswer in question.incorrectAnswers {
                incorrectAnswers.append(incorrectAnswer)
            }
        }
        
        //MARK: Translete correctAnswers
        // Пересобираем массив вопросов - тепрь там переведенные вопросы
        
        group.enter()
        translateManager.translateText(text: correctAnswers) { result in
            defer { group.leave() }
            switch result {
                
            case .success(let translatedCorrectAnswers):
                correctAnswers = []
                for answer in translatedCorrectAnswers {
                    correctAnswers.append(answer.text.htmlDecoded)
                }
                
            case .failure(let error):
                print("❌ERROR translate correct answers",error)
            }
        }
        
        //MARK: Translete incorrectAnswers
        
        group.enter()
        translateManager.translateText(text: incorrectAnswers) { result in
            defer { group.leave() }
            switch result {
                
            case .success(let translatedIncorrectAnswers): // array of all incorrect Answers
                var groupedIncorrectAnswers: [[String]] = []
                var tempGroup: [String] = [] // incorrect answers for one question
                
                for answer in translatedIncorrectAnswers {
                    tempGroup.append(answer.text.htmlDecoded) // add answer + delete html simbols
                    if tempGroup.count == 3 {
                        groupedIncorrectAnswers.append(tempGroup)
                        tempGroup = []
                    }
                }
                
                incorrectAnswersGroups = groupedIncorrectAnswers // массив с массивами ответов на каждый вопрос по порядку/ потом пересобрать...
                
            case .failure(let error):
                print("❌translate incorrect answers",error)
            }
        }
        
        //MARK: Translete questions
        group.enter()
        translateManager.translateText(text: questions) { result in
            defer { group.leave() }
            switch result {
            case .success(let translatedText):
                questions = [] // remove all english questions
                
                for text in translatedText {
                    questions.append(text.text)
                }
                
            case .failure(let error):
                print("❌STORAGE TRANSLATER (questions) ERROR --->>>", error)
            }
        }
        
        //MARK: Set new russian questions in Question Type
        
        group.notify(queue: .main) {
            guard questions.count == 15 else { print("❌Error, question count not equal to 15, guestion count - \(questions.count)"); return }
            guard incorrectAnswersGroups.count == 15 else { print("❌Error, incorrect answersGroup count not equal to 15"); return }
            guard correctAnswers.count == 15 else { print("❌Error, correct answers count not equal to 15"); return }
            
            for index in 0..<15 {
                let newTranslatenQuestion = Question(type: self.gameQuestions[index].type,
                                                     difficulty: self.gameQuestions[index].difficulty,
                                                     category: self.gameQuestions[index].category,
                                                     question: questions[index].htmlDecoded,
                                                     correctAnswer: correctAnswers[index].htmlDecoded,
                                                     incorrectAnswers: incorrectAnswersGroups[index])
                self.translatedGameQuestions.append(newTranslatenQuestion)
            }
            print("✅ STORAGE transleted all questions --_>>", self.translatedGameQuestions)

//#warning("check UD") // save russian questions in UD
            do {
                let data = try JSONEncoder().encode(self.translatedGameQuestions)
                UserDefaults.standard.set(data, forKey: "translatedGameQuestions")
                print("💼 𝌰 ENCODE russian questions Complete")
            } catch {
                print("❌ 𝌰 ENCODE Error \(error)")
            }
        }
    }
    
    func setGameQuestions() {
        networManager.fetchGameQuestions { result in
            switch result {
            case .success(let questions):
                self.gameQuestions = [] // clear old questions
                self.gameQuestions = questions
                
//#warning("check UD") //save english questions in UD
                do {
                    let data = try JSONEncoder().encode(questions)
                    UserDefaults.standard.set(data, forKey: "gameQuestions")
                    print("💼 𝌰 ENCODE english Complete")
                } catch {
                    print("❌ 𝌰 ENCODE Error \(error)")
                }
                
                if self.translationEnabled != "off" {
                    self.translatedGameQuestions = []  //clear old questions
                    self.translateGameQuestions(englishQuestions: questions)
                }
            
            case .failure(let error):
                print("❌StorageManager -->",error)
            }
        }
    }
}



// Worked " reserve :)" class, but work with questions only // It doesn't translate the answers. -->>

//
//class StorageManager {
//    let networManager = NetworkManager()
//    let translateManager = TranslaterManager()
//    var translationEnabled = UserDefaults.standard.string(forKey: "translationEnabled") ?? "off" // settingsView
//
//    var gameQuestions: [Question] = []
//    var translatedGameQuestions: [Question] = []
//
//    func setGameQuestions() {
//        networManager.fetchGameQuestions { result in
//            switch result {
//            case .success(let questions):
//                self.gameQuestions = questions
//                self.translateGameQuestions(englishQuestions: questions)
//
//                print(self.gameQuestions)
//                print(self.translatedGameQuestions)
//                // UD save
//            case .failure(let error):
//                print("StorageManager -->",error)
//            }
//        }
//    }
//
//    private func translateGameQuestions(englishQuestions: [Question]) {
//        var questions: [String] = []
//
//        for question in englishQuestions {
//            questions.append(question.question)
//        }
//
//        translateManager.translateText(text: questions) { result in
//            switch result {
//            case .success(let translatedText):
//                var translatedStrings: [String] = [] // all russian questions
//
//                for text in translatedText {
//                    translatedStrings.append(text.text)
//                }
//
//                for index in 0..<15 {
//                    let newTranslatenQuestion = Question(type: "translated",
//                                                         difficulty: "translated",
//                                                         category: "translated",
//                                                         question: translatedStrings[index],
//                                                         correctAnswer: self.gameQuestions[index].correctAnswer,
//                                                         incorrectAnswers: self.gameQuestions[index].incorrectAnswers)
//                    self.translatedGameQuestions.append(newTranslatenQuestion)
//                }
//                print (self.translatedGameQuestions)
//
//            case .failure(_):
//                print("STARAGE TRANSLATER ERROR __>>")
//            }
//        }
//
//    }
//}
