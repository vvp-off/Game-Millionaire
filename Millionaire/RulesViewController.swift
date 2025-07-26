//
//  RulesViewController.swift
//  Millionaire
//
//  Created by Nurislam on 26.07.2025.
//

import UIKit

class RulesViewController: UIViewController {
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "Background")
        imageView.image = image
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("← Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game Rules"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rulesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        
        let rulesText = """
🎮 HOW TO PLAY

The goal is to answer 15 questions correctly to win 1,000,000 rubles!

💰 PRIZE STRUCTURE

1. 500 rubles
2. 1,000 rubles  
3. 2,000 rubles
4. 3,000 rubles
5. 5,000 rubles 🔒 (Safe amount)
6. 7,500 rubles
7. 10,000 rubles
8. 12,500 rubles
9. 15,000 rubles
10. 25,000 rubles 🔒 (Safe amount)
11. 50,000 rubles
12. 100,000 rubles
13. 250,000 rubles
14. 500,000 rubles
15. 1,000,000 rubles 🏆 (Winner!)

⏰ TIME LIMIT

You have 30 seconds to answer each question.
If time runs out, the game ends.

💡 LIFELINES (3 available)

🎯 50/50: Removes 2 wrong answers
👥 Ask the Audience: Shows popular vote
❤️ Second Chance: One wrong answer allowed

💸 TAKE THE MONEY

You can stop anytime and take your current winnings.

🔒 SAFE AMOUNTS

If you answer incorrectly, you keep the last safe amount:
- Question 5: 5,000 rubles
- Question 10: 25,000 rubles  
- Question 15: 1,000,000 rubles

Good luck! 🍀
"""
        
        label.text = rulesText
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(rulesLabel)
    }
    
    private func setupConstraints() {
        // Background
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Back button
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        // Title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // ContentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Rules text
        NSLayoutConstraint.activate([
            rulesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            rulesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rulesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rulesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 
