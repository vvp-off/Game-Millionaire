import UIKit

struct MoneyForQuestionModel {
    let numberOfQuestions: Int
    let money: Int
}

final class MainViewController: UIViewController {

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

    private let gameService = GameService()
    private let soundService = SoundService()

    private var timer: Timer?
    private var totalTime = 30
    private var secondsPassed = 0

    private let imageOneBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .ellipse7)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let imageTwoBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .ellipse6)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let questionNumberStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let questionNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Compact Text", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "QUESTION 1"
        label.textColor = UIColor(hex: "#98ACCF")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFCompactDisplay-Semibold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "$500"
        label.textColor = UIColor(hex: "#FFFFFF")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Loading questions..."
        label.textColor = UIColor(hex: "#FFFFFF")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let timerView = TimerView(
        backgroundColor: UIColor.white.withAlphaComponent(0.1),
        icon: UIImage(resource: .stopwatchWhite),
        textColor: .white
    )

    private let answerAButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "Loading...",
        prefix: "A:"
    )

    private let answerBButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "Loading...",
        prefix: "B:"
    )

    private let answerCButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "Loading...",
        prefix: "C:"
    )

    private let answerDButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "Loading...",
        prefix: "D:"
    )

    private let helpButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 26
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let fiftyPercentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: ._50_50), for: .normal)
        button.addTarget(
            self,
            action: #selector(fiftyPercentAction),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let helpAudienceButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: .audience), for: .normal)
        button.addTarget(
            self,
            action: #selector(helpAudiencebuttonAction),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let callFriendButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: .call), for: .normal)
        button.addTarget(
            self,
            action: #selector(callFriendbuttonAction),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupButtons()
        setupGradient()
        setupNavigationBar()
        gameService.loadData()
        onDataLoaded()
    }

    // MARK: - Setup UI

    private func onDataLoaded() {
        gameService.onDataLoaded = { [weak self] in
            self?.gameService.startGame()
            self?.startTimer(time: 30)
            
            if let question = self?.gameService.getCurrentQuestion() {
                self?.updateQuestionUI(with: question, number: self?.gameService.getQuestionNumber() ?? 1)
            }
        }
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#374C94").cgColor,
            UIColor(hex: "#100E16").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupNavigationBar() {
        let stack = questionNumberStackView
        stack.addArrangedSubview(questionNumberLabel)
        stack.addArrangedSubview(moneyLabel)
        
        navigationItem.titleView = stack
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .barChart),
            style: .plain,
            target: self,
            action: #selector(questionChartButtonAction)
        )
    }

    private func updateQuestionUI(with question: Question, number: Int) {
        questionLabel.text = question.question
        questionNumberLabel.text = "QUESTION \(number)"
        moneyLabel.text = "$\(moneyForQuestion[number-1].money)"

        let answers = question.allAnswers
        answerAButton.setTitle(title: answers[0])
        answerBButton.setTitle(title: answers[1])
        answerCButton.setTitle(title: answers[2])
        answerDButton.setTitle(title: answers[3])
    
        [answerAButton, answerBButton, answerCButton, answerDButton].forEach { button in
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
            button.setBackground(UIImage(resource: .rectangleBlue))
        }
    }

    private func setupButtons() {
        answerAButton.addTarget(self, action: #selector(buttonAAction), for: .touchUpInside)
        answerBButton.addTarget(self, action: #selector(buttonBAction), for: .touchUpInside)
        answerCButton.addTarget(self, action: #selector(buttonCAction), for: .touchUpInside)
        answerDButton.addTarget(self, action: #selector(buttonDAction), for: .touchUpInside)

        answerAButton.isUserInteractionEnabled = true
        answerBButton.isUserInteractionEnabled = true
        answerCButton.isUserInteractionEnabled = true
        answerDButton.isUserInteractionEnabled = true

        fiftyPercentButton.isUserInteractionEnabled = true
        helpAudienceButton.isUserInteractionEnabled = true
        callFriendButton.isUserInteractionEnabled = true
    }

    private func startTimer(time: Int) {
        totalTime = time
        secondsPassed = 0

        timerView.updateLabel(text: totalTime - secondsPassed)

        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: - Actions

private extension MainViewController {

    @objc
    private func questionChartButtonAction() {
        // TODO: - Сделать переход на некст экран
    }

    @objc
    func buttonAAction() {
        timer?.invalidate()
        answerButtonTapped(answerAButton)
    }

    @objc
    func buttonBAction() {
        timer?.invalidate()
        answerButtonTapped(answerBButton)
    }

    @objc
    func buttonCAction() {
        timer?.invalidate()
        answerButtonTapped(answerCButton)
    }

    @objc
    func buttonDAction() {
        timer?.invalidate()
        answerButtonTapped(answerDButton)
    }

    @objc
    func fiftyPercentAction() {
        let fiftyPercentAnswer = gameService.getFiftyOnFiftyAnswerIndexes()

        let allButtons = [answerAButton, answerBButton, answerCButton, answerDButton]
        for button in allButtons {
            button.isUserInteractionEnabled = false
            button.alpha = 0.0
        }

        for index in fiftyPercentAnswer {
            let button = allButtons[index]
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        }

        fiftyPercentButton.isUserInteractionEnabled = false
        fiftyPercentButton.alpha = 0.5
    }

    @objc
    func helpAudiencebuttonAction() {
        let percentages = gameService.audienceDistribution()

        helpAudienceButton.isUserInteractionEnabled = false
        helpAudienceButton.alpha = 0.5

        let audienceVC = AudienceHelpViewController()
        audienceVC.percentages = percentages

        audienceVC.modalPresentationStyle = .pageSheet
        
        if let sheet = audienceVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        present(audienceVC, animated: true)
    }

    @objc
    func callFriendbuttonAction() {
        let answer = gameService.callFriend()
        callFriendButton.isUserInteractionEnabled = false
        callFriendButton.alpha = 0.5

        let friendVC = FriendHelpViewController()
        friendVC.friendAnswer = answer
        friendVC.modalPresentationStyle = .pageSheet
        if let sheet = friendVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(friendVC, animated: true)

        callFriendButton.isUserInteractionEnabled = false
        callFriendButton.alpha = 0.5
    }

    @objc
    func timerTick() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            timerView.updateLabel(text: totalTime - secondsPassed)
        } else {
            timer?.invalidate()

            let mainViewController = LevelScreenViewController()
            navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
    func answerButtonTapped(_ button: AnswerButton) {
        timer?.invalidate()
        button.flash(duration: 0.5)
        soundService.play(sound: .choiseIsMade)
        let selectedAnswer = button.getAnswerText()!

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            let isCorrect = self.gameService.selectAnswer(selectedAnswer)
            
            let backgroundImage = isCorrect
            ? UIImage(resource: .rectangleGreen)
            : UIImage(resource: .rectangleRed)
            button.setBackground(backgroundImage)
            
            //Вызов следующего экрана
            let mainViewController = LevelScreenViewController()
            navigationController?.pushViewController(mainViewController, animated: true)
           
        }

        answerAButton.isUserInteractionEnabled = false
        answerBButton.isUserInteractionEnabled = false
        answerCButton.isUserInteractionEnabled = false
        answerDButton.isUserInteractionEnabled = false
        
        fiftyPercentButton.isUserInteractionEnabled = false
        helpAudienceButton.isUserInteractionEnabled = false
        callFriendButton.isUserInteractionEnabled = false
    }
}

// MARK: - Setup Consraints

private extension MainViewController {
    func addSubviews() {
        view.addSubview(imageOneBackground)
        view.addSubview(imageTwoBackground)

        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(questionLabel)

        view.addSubview(questionStackView)
        questionStackView.addArrangedSubview(answerAButton)
        questionStackView.addArrangedSubview(answerBButton)
        questionStackView.addArrangedSubview(answerCButton)
        questionStackView.addArrangedSubview(answerDButton)
        
        view.addSubview(helpButtonStackView)
        helpButtonStackView.addArrangedSubview(fiftyPercentButton)
        helpButtonStackView.addArrangedSubview(helpAudienceButton)
        helpButtonStackView.addArrangedSubview(callFriendButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                imageOneBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
                imageOneBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                imageOneBackground.widthAnchor.constraint(equalToConstant: 321),
                imageOneBackground.heightAnchor.constraint(equalToConstant: 321),

                imageTwoBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
                imageTwoBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

                timerView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 32),
                timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                questionLabel.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 24),
                questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                questionLabel.heightAnchor.constraint(equalToConstant: 150),

                questionStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
                questionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                questionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                helpButtonStackView.topAnchor.constraint(equalTo: questionStackView.bottomAnchor, constant: 40),
                helpButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                helpButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                helpButtonStackView.heightAnchor.constraint(equalToConstant: 64),
            ]
        )
    }
}
