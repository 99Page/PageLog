//
//  SceneDelegate.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit

// iOS 26부터는 SceneDelegate가 강제됩니다.
// reference: https://developer.apple.com/videos/play/wwdc2025/243/?time=1238
// -page, 2025. 06. 22 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: MainViewController())
        self.window = window
        window.makeKeyAndVisible()
    }
}
