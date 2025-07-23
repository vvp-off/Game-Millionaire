import UIKit
import AVFoundation

final class MainViewController: UIViewController {

    private var answerIsCorrect: Bool = false
    private var secondsRemaining = 60
    private var totalTime = 0
    private var secondsPassed = 0
    private var remainingTime = 0

    private var viewModel = MainViewModel()
    
    private var player: AVAudioPlayer!
    private var timer: Timer?

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

    private let moneylabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFCompactDisplay-Semibold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "$500"
        label.textColor = UIColor(hex: "#FFFFFF")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionlabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "SFCompactDisplay-Semibold", size: 24)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "What year was the year, when first deodorant was invented in our life?"
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

    private let questionChartButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: .barChart), for: .normal)
        button.addTarget(
            nil,
            action: #selector(questionChartButtonAction),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let timerView = TimerView(
        backgroundColor: UIColor.white.withAlphaComponent(0.1),
        icon: UIImage(resource: .stopwatchWhite),
        textColor: .white
    )

    private let answerAButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "",
        prefix: "A:"
    )

    private let answerBButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "",
        prefix: "B:"
    )

    private let answerCButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "",
        prefix: "C:"
    )

    private let answerDButton = AnswerButton(
        image: UIImage(resource: .rectangleBlue),
        answerText: "",
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
        button.addTarget(nil, action: #selector(fiftyPercentAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let helpAudienceButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: .audience), for: .normal)
        button.addTarget(nil, action: #selector( helpAudiencebuttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let callFriendButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(resource: .call), for: .normal)
        button.addTarget(nil, action: #selector(callFriendbuttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
// TODO: - когда будуь шрифты
//        for family in UIFont.familyNames.sorted() {
//            print("🧩 Шрифт: \(family)")
//            let fontNames = UIFont.fontNames(forFamilyName: family)
//            for name in fontNames {
//                print("   ↪︎ \(name)")
//            }
//        }

        addSubviews()
        setupConstraints()
        setupButtons()
        setupGradient()
        updateQuestion()
        
        playSound(resource: "ZvukChasov")
        
        viewModel.loadQuestions()
        viewModel.onUpdate = { [weak self] in
            self?.updateQuestion()
            self?.startTimer(time: 30)
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

    @objc
    private func updateQuestion() {
        questionlabel.text = viewModel.getQuestionText()
        questionNumberLabel.text = "QUESTION \(viewModel.numberOfQuestions + 1)"
        moneylabel.text = "$\(viewModel.getMoneyForQuestion())"

        answerAButton.setTitle(title: viewModel.getAnswerText(userButtonNumber: 0))
        answerBButton.setTitle(title: viewModel.getAnswerText(userButtonNumber: 1))
        answerCButton.setTitle(title: viewModel.getAnswerText(userButtonNumber: 2))
        answerDButton.setTitle(title: viewModel.getAnswerText(userButtonNumber: 3))

        [answerAButton, answerBButton, answerCButton, answerDButton].forEach { button in
            button.alpha = 1.0
            button.isUserInteractionEnabled = true
        }
    }

    private func setupButtons() {
        answerAButton.addTarget(
            self,
            action: #selector(buttonAAction),
            for: .touchUpInside
        )

        answerBButton.addTarget(
            self,
            action: #selector(buttonBAction),
            for: .touchUpInside
        )

        answerCButton.addTarget(
            self,
            action: #selector(buttonCAction),
            for: .touchUpInside
        )
        
        answerDButton.addTarget(
            self,
            action: #selector(buttonDAction),
            for: .touchUpInside
        )
    }
    
    @objc
    private func questionChartButtonAction() {
        viewModel.nextQuestion()
        updateQuestion()
        timer!.invalidate()
        startTimer(time: 30)
    }

    @objc
    private func buttonAAction() {
        timer?.invalidate()
        answerAButton.flash(duration: 0.5)
        playSound(resource: "OtvetPrinyat")
        
        let selectedAnswer = answerAButton.getAnswerText()

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.handleAnswerSelection(for: selectedAnswer, button: self.answerAButton)
        }
    }

    @objc
    private func buttonBAction() {
        timer?.invalidate()
        answerBButton.flash(duration: 0.5)
        playSound(resource: "OtvetPrinyat")

        let selectedAnswer = answerBButton.getAnswerText()

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.handleAnswerSelection(for: selectedAnswer, button: answerBButton)
        }
    }

    @objc
    private func buttonCAction() {
        timer?.invalidate()
        answerCButton.flash(duration: 0.5)
        playSound(resource: "OtvetPrinyat")

        let selectedAnswer = answerCButton.getAnswerText()

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.handleAnswerSelection(for: selectedAnswer, button: answerCButton)
        }
    }

    @objc
    private func buttonDAction() {
        timer?.invalidate()
        answerDButton.flash(duration: 0.5)
        playSound(resource: "OtvetPrinyat")

        let selectedAnswer = answerDButton.getAnswerText()

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.handleAnswerSelection(for: selectedAnswer, button: answerDButton)
        }
    }

    private func handleAnswerSelection(for answer: String?, button: AnswerButton) {
        let isCorrect = viewModel.checkAnswer(userAnswer: answer)
        let backgroundImage = isCorrect
            ? UIImage(resource: .rectangleGreen)
            : UIImage(resource: .rectangleRed)
        let musicSound = isCorrect
            ? "OtvetVernyiy"
            : "OtvetNepravilnyiy"
        
        playSound(resource: musicSound)
        button.setBackground(backgroundImage)
    }
 
    @objc
    private func fiftyPercentAction() {
        let fiftyPercentAnswer = viewModel.fiftyPercent()

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
        fiftyPercentButton.alpha = 0.0
    }

    @objc
    private func helpAudiencebuttonAction() {
        let fiftyPercentAnswer = viewModel.seventyPercent()

        let allButtons = [answerAButton, answerBButton, answerCButton, answerDButton]
        for button in allButtons {
            button.isUserInteractionEnabled = false
            button.alpha = 0.0
        }

        let button = allButtons[fiftyPercentAnswer]
        button.isUserInteractionEnabled = true
        button.alpha = 1.0

        helpAudienceButton.isUserInteractionEnabled = false
        helpAudienceButton.alpha = 0.0
    }
    
    @objc
    private func callFriendbuttonAction() {
        let eightyPercentAnswer = viewModel.seventyPercent()
        let allButtons = [answerAButton, answerBButton, answerCButton, answerDButton]
        for button in allButtons {
            button.isUserInteractionEnabled = false
            button.alpha = 0.0
        }
        let button = allButtons[eightyPercentAnswer]
        button.isUserInteractionEnabled = true
        button.alpha = 1.0
        
        callFriendButton.isUserInteractionEnabled = false
        callFriendButton.alpha = 0.0
    }

    private func startTimer(time: Int) {
        totalTime = time
        secondsPassed = 0
    
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }

    private func playSound(resource: String) {
        let url = Bundle.main.url(forResource: resource, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }

    @objc
    private func updateTimer() {
        if  secondsPassed < totalTime {
            secondsPassed += 1
            remainingTime = totalTime-secondsPassed

            timerView.updateLabel(text: remainingTime)

            if remainingTime == 12 {
                timerView.setBackgroundColor(UIColor(hex: "#FFA800"), alphaComponent: 0.3)
                timerView.setIcon (UIImage(resource: .stopwatchOrange))
                timerView.setTextColor(UIColor(hex: "#FFB340"))
            }
            
            if remainingTime == 3 {
                timerView.setBackgroundColor(UIColor(hex: "#832203"), alphaComponent: 0.5)
                timerView.setIcon (UIImage(resource: .stopwatchRed))
                timerView.setTextColor(UIColor(hex: "#FF6231"))
            }
        } else {
            questionlabel.text = "Time is over!"
        }
    }
}

// MARK: - Setup Constraints

private extension MainViewController {
    func addSubviews() {
        view.addSubview(imageOneBackground)
        view.addSubview(imageTwoBackground)

        view.addSubview(questionNumberStackView)
        questionNumberStackView.addArrangedSubview(questionNumberLabel)
        questionNumberStackView.addArrangedSubview(moneylabel)

        view.addSubview(questionChartButton)
        
        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(questionlabel)

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

                questionNumberStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
                questionNumberStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 76),
                questionNumberStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -76),

                questionChartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
                questionChartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                questionChartButton.heightAnchor.constraint(equalToConstant: 32),
                questionChartButton.widthAnchor.constraint(equalToConstant: 32),

                timerView.topAnchor.constraint(equalTo: questionNumberStackView.bottomAnchor, constant: 32),
                timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                questionlabel.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 24),
                questionlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                questionlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                questionlabel.heightAnchor.constraint(equalToConstant: 150),

                questionStackView.topAnchor.constraint(equalTo: questionlabel.bottomAnchor, constant: 40),
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
