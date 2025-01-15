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
        
        // 시작할 ViewController 설정
        let rootViewController = ChatViewController(store: Store(initialState: ChatFeature.State(chats: MessageState.stubs), reducer: {
            ChatFeature()
        })) // 메인 화면
        let navigationController = UINavigationController(rootViewController: rootViewController) // 네비게이션 컨트롤러
        
        // 윈도우의 루트 뷰 컨트롤러 설정
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
