//
//  SceneDelegate.swift
//  AboutXcode
//
//  Created by 노우영 on 10/27/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
