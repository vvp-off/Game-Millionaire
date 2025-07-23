//
//  ProgressViewCell.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import UIKit

class LevelViewCell: UITableViewCell {
    static let identifier = "LevelViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var amountOfMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    func configure(number: String, amountOfMoney: String) {
        questionLabel.text = number
        amountOfMoneyLabel.text = amountOfMoney
    }
    
    func setQuestionImage(image: UIImage) {
        questionImageView.image = image
    }
}

private extension LevelViewCell {
    func setupViews() {
        contentView.addSubview(questionImageView)
        questionImageView.addSubview(questionLabel)
        questionImageView.addSubview(amountOfMoneyLabel)
        
        questionImageView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        amountOfMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            questionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            questionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            questionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            amountOfMoneyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            amountOfMoneyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
