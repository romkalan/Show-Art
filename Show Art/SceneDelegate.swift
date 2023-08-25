//
//  SceneDelegate.swift
//  Show Art
//
//  Created by Roman Lantsov on 25.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var statusInfo = false
    private let userDefaults = UserDefaults.standard

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if userDefaults.bool(forKey: "status") == false {
            window?.rootViewController = OnboardingViewController.instantiate()
            statusInfo = true
            userDefaults.set(statusInfo, forKey: "status")
        } else {
            window?.rootViewController = ViewController.instantiate()
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

