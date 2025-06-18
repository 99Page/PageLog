//
//  AppDelegate.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import ComposableArchitecture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // UIWindow 생성 및 초기화
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 윈도우의 루트 뷰 컨트롤러 설정
        window?.rootViewController = MyAlertViewController(store: Store(initialState: AlertFeature.State(), reducer: {
            AlertFeature()
        }))
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
