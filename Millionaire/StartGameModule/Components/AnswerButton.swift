import UIKit

final class AnswerButton: UIControl {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let prefixLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "SF Compact Text", size: 18)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(hex: "##E19B30")
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "SF Compact Text", size: 18)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 3
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(
        image: UIImage?,
        answerText: String,
        prefix: String
    ) {
        super.init(frame: .zero)

        prefixLabel.text = prefix
        answerLabel.text = answerText
        backgroundImageView.image = image

        addSubviews()
        setupConstraints()
        setTitle(title: answerText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(title: String?) {
        answerLabel.text = title
    }

    func setBackground(_ image: UIImage?) {
        backgroundImageView.image = image
    }
}

extension AnswerButton {
    func flash(repeatCount: Int = 5, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float(repeatCount)

        self.layer.add(animation, forKey: "flash")
    }
}

extension AnswerButton {
    func getAnswerText() -> String? {
        return answerLabel.text
    }
}

private extension AnswerButton {
    func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(horizontalStack)

        horizontalStack.addArrangedSubview(prefixLabel)
        horizontalStack.addArrangedSubview(answerLabel)
    }
    
     func setupConstraints() {
         NSLayoutConstraint.activate(
            [
                backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

                horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                horizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ]
         )
    }
}


