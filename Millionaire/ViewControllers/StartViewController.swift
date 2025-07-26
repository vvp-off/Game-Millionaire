//
//  ViewController.swift
//  Millionaire
//
//  Created by VP on 19.07.2025.
//

import UIKit

class StartViewController: UIViewController {
    
    let gameService = GameService()
    
    let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "Background")
        imageView.image = image
        return imageView
    }()
    
    let helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        button.addTarget(nil, action: #selector(helpButtonTaped), for: .touchUpInside)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    let mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "IconMillioner")
        imageView.widthAnchor.constraint(equalToConstant: 195).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 195).isActive = true
        imageView.image = image
        return imageView
    }()
    
    let mainTextLabelTitle: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Who Wants\n to be a Millionare"
        text.font = UIFont.boldSystemFont(ofSize: 32)
        text.textColor = .white
        text.textAlignment = .center
        text.numberOfLines = 0
        return text
    }()
    
    let mainTextAndLogoStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .center
        return sv
    }()
    
    lazy var bestScoreLabelTitel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "All-time Best Score"
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = .white
        text.alpha = 0.5
        return text
    }()
    
    lazy var bestScoreCoin: UIImageView = {
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
        text.text = "$\(gameService.getBestScoreValue())"
        text.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        text.textColor = .white
        return text
    }()
    
    lazy var coinAndValueStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 1.5
        sv.alignment = .center

        return sv
    }()
    
    lazy var bestScoreStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    
    lazy var bestScoreAndMainLogoStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .center
        return sv
    }()
    
    lazy var startGameButton: UIButton = {
        return createButton(with: "Start game", action: startGameButtonAction, bgImage: "blueButton")
    }()
    
    lazy var continueGameButton: UIButton = {
        return createButton(with: "Continue game", action: startGameButtonAction, bgImage: "orangeButton")
    }()
    
    private func createButton(with title: String, action: @escaping () -> Void, bgImage: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.heightAnchor.constraint(equalToConstant: 62).isActive = true
        button.setBackgroundImage(UIImage(named: bgImage), for: .normal)
        
        let action = UIAction { _ in action() }
        button.addAction(action, for: .touchUpInside)
        
        return button
    }
    
    lazy var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        return sv
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.backButtonTitle = ""
    }

    
    override func viewDidLoad() {
        
        // STORAGE MANAGER
//        StorageManager().setGameQuestions()
        
        
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        view.addSubview(helpButton)
        
        NSLayoutConstraint.activate([
            helpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            helpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
        
        view.addSubview(bestScoreAndMainLogoStackView)
        
        NSLayoutConstraint.activate([
            bestScoreAndMainLogoStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            bestScoreAndMainLogoStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            bestScoreAndMainLogoStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            bestScoreAndMainLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        bestScoreAndMainLogoStackView.addArrangedSubview(mainTextAndLogoStackView)

        mainTextAndLogoStackView.addArrangedSubview(mainLogoImageView)
        mainTextAndLogoStackView.addArrangedSubview(mainTextLabelTitle)
        
        //TODO: реализовать метод, который возвращает есть ли лучший результат
        if gameService.isBestScore() {
            bestScoreAndMainLogoStackView.addArrangedSubview(bestScoreStackView)
            
            bestScoreStackView.addArrangedSubview(bestScoreLabelTitel)
            bestScoreStackView.addArrangedSubview(coinAndValueStackView)
            
            coinAndValueStackView.addArrangedSubview(bestScoreCoin)
            coinAndValueStackView.addArrangedSubview(bestScoreValueLabel)
        }

        
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -109),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        buttonsStackView.addArrangedSubview(startGameButton)
        //TODO: реализовать метод, который возвращает есть ли незавершенная игра
        if gameService.isUnfinishedGame() {
            buttonsStackView.insertArrangedSubview(continueGameButton, at: 0)
        }
    }
    
    @objc
    private func helpButtonTaped() {
        let rulesVC = RulesViewController()
        present(rulesVC, animated: true)
    }

    @objc
    private func startGameButtonAction() {
        let mainViewController = MainViewController()
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    //TODO: вероятно нужно как то иначе делать переход так как данные идут не с нуля
    @objc
    private func continueGameButtonAction() {
        let mainViewController = MainViewController()
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
