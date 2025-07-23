//
//  SoundService.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import AVFoundation

enum GameSound: String {
    case wrongAnswer = "OtvetNepravilnyiy"
    case choiseIsMade = "OtvetPrinyat"
    case correctAnswer = "OtvetVernyiy"
    case timeTicking = "ZvukChasov"
    case gameWin = "ZvukPobedu"
}

class SoundService {
    private var audioPlayer: AVAudioPlayer?
    
    func play(sound: GameSound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            print("Sound is not found: \(sound.rawValue).mp3")
            return
        }
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
