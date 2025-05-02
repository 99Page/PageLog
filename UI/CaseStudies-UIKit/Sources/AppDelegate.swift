//
//  AppDelegate.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 4/24/25.
//  Copyright © 2025 Page. All rights reserved.
//


import UIKit

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
        window?.rootViewController = ExpandableCollectionViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()
        
        return true
    }
}
