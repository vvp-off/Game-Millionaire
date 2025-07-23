import UIKit

final class TimerView: UIView {

    private let iconImageView = UIImageView()
    private let timeLabel = UILabel()
    private var timer: Timer?
    private var remainingSeconds: Int = 0

    init(
        backgroundColor: UIColor = UIColor.white.withAlphaComponent(0.1),
        icon: UIImage? = UIImage(resource: .stopwatchWhite),
        textColor: UIColor = .white
    ) {
        super.init(frame: .zero)
        setupView(backgroundColor: backgroundColor, icon: icon, textColor: textColor)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(
            backgroundColor: UIColor.white.withAlphaComponent(0.1),
            icon: UIImage(resource: .stopwatchWhite),
            textColor: .white
        )
    }

    private func setupView(backgroundColor: UIColor, icon: UIImage?, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 25
        clipsToBounds = true

        iconImageView.image = icon
        iconImageView.tintColor = textColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.font = UIFont(name: "SFCompactDisplay-Semibold", size: 24)
        timeLabel.textColor = textColor
        timeLabel.textAlignment = .left
        timeLabel.text = "30"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [iconImageView, timeLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func updateLabel(text: Int) {
        timeLabel.text = String(text)
    }

    func setIcon(_ image: UIImage?) {
        iconImageView.image = image
    }

    func setTextColor(_ color: UIColor) {
        timeLabel.textColor = color
        iconImageView.tintColor = color
    }

    func setBackgroundColor(_ color: UIColor, alphaComponent: CGFloat = 0.3) {
        backgroundColor = color.withAlphaComponent(alphaComponent)
    }

}
