import UIKit

final class AudienceHelpViewController: UIViewController {

    var percentages: [Int: Int] = [:]

    private let barColors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed]
    private let answerLabels = ["A", "B", "C", "D"]

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradient()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
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
        self.gradientLayer = gradientLayer
    }

    private func setupUI() {
        view.backgroundColor = .clear

        addSubviews()
        setupConstraints()
        charts()
    }
    
    private func charts() {
        let maxBarHeight: CGFloat = 200
        let barWidth: CGFloat = 50

        for (index, answerLabel) in answerLabels.enumerated() {
            let percent = percentages[index] ?? 0

            let barContainer = UIView()
            barContainer.translatesAutoresizingMaskIntoConstraints = false
            barContainer.widthAnchor.constraint(equalToConstant: barWidth).isActive = true

            let barView = UIView()
            barView.backgroundColor = barColors[index % barColors.count]
            barView.layer.cornerRadius = 8
            barView.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(barView)

            let percentLabel = UILabel()
            percentLabel.textAlignment = .center
            percentLabel.text = "\(percent)%"
            percentLabel.font = .systemFont(ofSize: 16, weight: .medium)
            percentLabel.textColor = .white
            percentLabel.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(percentLabel)
            let answerLabelView = UILabel()
            answerLabelView.textAlignment = .center
            answerLabelView.text = answerLabel
            percentLabel.textColor = .white
            answerLabelView.font = .systemFont(ofSize: 18, weight: .bold)
            answerLabelView.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(answerLabelView)

            NSLayoutConstraint.activate([
                percentLabel.topAnchor.constraint(equalTo: barContainer.topAnchor),
                percentLabel.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                percentLabel.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                percentLabel.heightAnchor.constraint(equalToConstant: 20),

                barView.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 8),
                barView.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                barView.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                barView.heightAnchor.constraint(equalToConstant: maxBarHeight * CGFloat(percent) / 100),

                answerLabelView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 8),
                answerLabelView.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                answerLabelView.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                answerLabelView.heightAnchor.constraint(equalToConstant: 22),
                answerLabelView.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor)
            ])

            stackView.addArrangedSubview(barContainer)
        }
    }
}

// MARK: - Setup Constraints

private extension AudienceHelpViewController {
    func addSubviews() {
        view.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                containerView.heightAnchor.constraint(equalToConstant: 280),

                stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]
        )
    }
}
