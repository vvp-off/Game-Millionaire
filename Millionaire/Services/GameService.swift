//
//  GameService.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import Foundation

protocol GameDelegate: AnyObject {
    
}

class GameService {
    weak var delegate: GameDelegate?
    
    private let soundService = SoundService()
    private let dataManager = DataManager()
    
    private var currentQuestionIndex = 0
    private var questions: [Question] = []
   
    
    private var fiftyOnFiftyIsOn = false
    private var audienceIsOn = false
    private var mistakeIsOn = false
    
    
    init() {
        loadData()
    }
    
    func loadData() {
        NetworkManager().fetchGameQuestions { result in
            switch result {
            case .success(let success):
                self.questions = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func startGame() {
        
    }
}

