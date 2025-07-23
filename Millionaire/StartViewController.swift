//
//  ViewController.swift
//  Millionaire
//
//  Created by VP on 19.07.2025.
//

import UIKit

class StartViewController: UIViewController {
    
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
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    let mainLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "IconMillioner")
        imageView.widthAnchor.constraint(equalToConstant: 195).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 195).isActive = true
        imageView.image = image
        return imageView
    }()
    
    let mainTextLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Who Wants\n to be a Millionare"
        text.font = UIFont.boldSystemFont(ofSize: 32)
        text.textColor = .white
        text.textAlignment = .center
        text.numberOfLines = 0
        return text
    }()
    
    let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New game", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.heightAnchor.constraint(equalToConstant: 62).isActive = true
        return button
    }()
    
    func createButtonMask(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.8818*width, y: 0.02206*height))
        path.addCurve(to: CGPoint(x: 0.93521*width, y: 0.14538*height),
                      controlPoint1: CGPoint(x: 0.90272*width, y: 0.02206*height),
                      controlPoint2: CGPoint(x: 0.92245*width, y: 0.06762*height))
        path.addLine(to: CGPoint(x: 0.99118*width, y: 0.48654*height))
        path.addLine(to: CGPoint(x: 0.99339*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.99118*width, y: 0.51346*height))
        path.addLine(to: CGPoint(x: 0.93521*width, y: 0.85462*height))
        path.addCurve(to: CGPoint(x: 0.8818*width, y: 0.97794*height),
                      controlPoint1: CGPoint(x: 0.92245*width, y: 0.93238*height),
                      controlPoint2: CGPoint(x: 0.90272*width, y: 0.97794*height))
        path.addLine(to: CGPoint(x: 0.1182*width, y: 0.97794*height))
        path.addCurve(to: CGPoint(x: 0.06479*width, y: 0.85462*height),
                      controlPoint1: CGPoint(x: 0.09728*width, y: 0.97794*height),
                      controlPoint2: CGPoint(x: 0.07755*width, y: 0.93238*height))
        path.addLine(to: CGPoint(x: 0.00881*width, y: 0.51346*height))
        path.addLine(to: CGPoint(x: 0.00661*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.00881*width, y: 0.48654*height))
        path.addLine(to: CGPoint(x: 0.06479*width, y: 0.14538*height))
        path.addCurve(to: CGPoint(x: 0.1182*width, y: 0.02206*height),
                      controlPoint1: CGPoint(x: 0.07755*width, y: 0.06762*height),
                      controlPoint2: CGPoint(x: 0.09728*width, y: 0.02206*height))
        path.close()
        return path
    }
    
    
    func applyPolygonMask(to button: UIButton) {
        let path = createButtonMask(rect: button.bounds)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        button.layer.mask = mask
    }
    
    func setGradientBackground(_ item: UIView) {
        if item.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(resource: .startGradient).cgColor,
                UIColor(resource: .endGradient).cgColor,
                UIColor(resource: .endGradient).cgColor,
                UIColor(resource: .startGradient).cgColor
            ]
            gradientLayer.locations = [0.0, 0.33, 0.8, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = item.bounds
            item.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func addBorder(to button: UIButton) {
        let path = createButtonMask(rect: button.bounds)
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = button.bounds

        button.layer.addSublayer(borderLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientBackground(startGameButton)
        applyPolygonMask(to: startGameButton)
        addBorder(to: startGameButton)
    }
    
    override func viewDidLoad() {
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
            helpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
        
        view.addSubview(mainLogoView)
        
        NSLayoutConstraint.activate([
            mainLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 163),
            mainLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(mainTextLabel)
        
        NSLayoutConstraint.activate([
            mainTextLabel.topAnchor.constraint(equalTo: mainLogoView.bottomAnchor, constant: 16),
            mainTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            mainTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            mainTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            startGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -109),
            startGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            startGameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
}
