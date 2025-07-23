//
//  LevelScreenViewController.swift
//  Millionaire
//
//  Created by Кирилл Бахаровский on 7/23/25.
//

import UIKit

class LevelScreenViewController: UIViewController {
    
    let questions = (1...15).reversed().map { "\($0):" }
    let amountOfMoney = [
        1000000,
        500000,
        250000,
        100000,
        50000,
        25000,
        15000,
        12500,
        10000,
        7500,
        5000,
        3000,
        2000,
        1000,
        500
    ]
    
    private lazy var takeTheMoney: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .takeTheMoney)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var logoView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .iconMillioner)
        return image
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .splash)
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(LevelViewCell.self, forCellReuseIdentifier: LevelViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
}

extension LevelScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountOfMoney.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LevelViewCell.identifier, for: indexPath) as? LevelViewCell else { return UITableViewCell() }
        cell.configure(number: questions[indexPath.row], amountOfMoney: ("$ " + formattedMoney()[indexPath.row]))
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.setQuestionImage(image: UIImage(resource: .questionLevelYellow))
        case 5, 10:
            cell.setQuestionImage(image: UIImage(resource: .questionLevelLightblue))
        default:
            cell.setQuestionImage(image: UIImage(resource: .questionLevelBlue))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print(questions[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        41
    }
    
    func formattedMoney() -> [String] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        let formattedAmounts = amountOfMoney.map { amount -> String in
            return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        }
        return formattedAmounts
    }
}

private extension LevelScreenViewController {
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        [backgroundImage, takeTheMoney, tableView, logoView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(takeTheMoneyTapped))
        takeTheMoney.addGestureRecognizer(tapGesture)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            takeTheMoney.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            takeTheMoney.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 85),
            logoView.widthAnchor.constraint(equalToConstant: 85),
            
            tableView.topAnchor.constraint(equalTo: logoView.topAnchor, constant: 70),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    @objc func takeTheMoneyTapped() {
        print(#function)
    }
}
