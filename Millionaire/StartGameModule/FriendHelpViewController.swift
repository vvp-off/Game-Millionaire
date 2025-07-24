import UIKit

final class FriendHelpViewController: UIViewController {

    var friendAnswer: String = ""

    private var gradientLayer: CAGradientLayer?

    private let portraitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource:.call)
        imageView.tintColor = .white
        return imageView
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

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
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }

    private func setupUI() {
        view.backgroundColor = .clear

        addSubviews()
        setupConstraints()

        answerLabel.text = friendAnswer
    }
}

// MARK: - Setup Constraints

private extension FriendHelpViewController {

    func addSubviews() {
        view.addSubview(portraitImageView)
        view.addSubview(answerLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                portraitImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                portraitImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                portraitImageView.widthAnchor.constraint(equalToConstant: 150),
                portraitImageView.heightAnchor.constraint(equalToConstant: 150),

                answerLabel.topAnchor.constraint(equalTo: portraitImageView.bottomAnchor, constant: 30),
                answerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                answerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ]
        )
    }
}
