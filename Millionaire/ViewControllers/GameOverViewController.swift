//
//  GameOverViewController.swift
//  Millionaire
//
//  Created by VP on 24.07.2025.
//

import UIKit

class GameOverViewController: UIViewController {
    
    let backGround: UIView = {
        let back = UIImageView()
        back.image = UIImage(named: "Background")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    let iconMillionaireImage: UIImageView = {
        let iconMillionaire = UIImageView()
        iconMillionaire.image = UIImage(named: "IconMillioner")
        iconMillionaire.translatesAutoresizingMaskIntoConstraints = false
        return iconMillionaire
    }()
    
    let labelGameOver: UILabel = {
        let label = UILabel()
        label.text = "Game over!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelLevel: UILabel = {
        let label = UILabel()
        var labelCorrect = "8"
        label.text = "Level \(GameService.shared.getQuestionNumber())"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.alpha = 0.5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bestScoreCoin: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "coin")
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.image = image
        return imageView
    }()
    
    lazy var bestScoreValueLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "$\(GameService.shared.getBestScoreValue())"
        text.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        text.textColor = .white
        return text
    }()
        
    let buttonMainScreen: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ButtonBase"), for: .normal)
        button.setTitle("Main screen", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.addTarget(nil, action: #selector(tapedButtonMaineScreen), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonNewGame: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ButtonOrange"), for: .normal)
        button.setTitle("New Game", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.addTarget(nil, action: #selector(tapedButtonNewGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setConstraint(){
        NSLayoutConstraint.activate([
            backGround.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGround.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGround.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGround.topAnchor.constraint(equalTo: view.topAnchor),
            
            iconMillionaireImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            iconMillionaireImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            iconMillionaireImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 122),
            iconMillionaireImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -451),
             
            labelGameOver.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            labelGameOver.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            labelGameOver.topAnchor.constraint(equalTo: iconMillionaireImage.bottomAnchor, constant: 16),
            
            labelLevel.topAnchor.constraint(equalTo: labelGameOver.bottomAnchor, constant: 16),
            labelLevel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            labelLevel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            bestScoreValueLabel.topAnchor.constraint(equalTo: labelLevel.bottomAnchor, constant: 8 ),
            bestScoreValueLabel.trailingAnchor.constraint(equalTo: bestScoreCoin.leadingAnchor ),
            
            bestScoreCoin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 222),
            bestScoreCoin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -129),
            bestScoreCoin.topAnchor.constraint(equalTo: labelLevel.bottomAnchor, constant: 8 ),
            bestScoreCoin.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -322),
            
            buttonNewGame.topAnchor.constraint(equalTo: iconMillionaireImage.bottomAnchor, constant: 251),
            buttonNewGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -138),
            buttonNewGame.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 32),
            buttonNewGame.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -32),
            
            buttonMainScreen.topAnchor.constraint(equalTo: buttonNewGame.bottomAnchor, constant: 16),
            buttonMainScreen.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            buttonMainScreen.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 32),
            buttonMainScreen.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -32),
            ])
    }
    
    @objc func tapedButtonNewGame(_ sender: UIButton) {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    @objc func tapedButtonMaineScreen(_ sender: UIButton) {
        navigationController?.pushViewController(StartViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backGround)
        view.addSubview(iconMillionaireImage)
        view.addSubview(labelGameOver)
        view.addSubview(labelLevel)
        view.addSubview(bestScoreValueLabel)
        view.addSubview(bestScoreCoin)
        view.addSubview(buttonMainScreen)
        view.addSubview(buttonNewGame)
        setConstraint()
    }
}
