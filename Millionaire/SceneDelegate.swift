//
//  SceneDelegate.swift
//  Millionaire
//
//  Created by VP on 19.07.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = StartViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "arrow_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "arrow_back")

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        
    }
}

