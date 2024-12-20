//
//  OverlayWindow.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

// 1. OverlayWindow 클래스 정의
class OverlayWindow {
    private var window: UIWindow?
    
    func showNotification<Content: View>(@ViewBuilder content: () -> Content, duration: TimeInterval = 3) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        // UIWindow 생성
        let window = PassthroughWindow(windowScene: scene)
        window.rootViewController = TransparentHostingController(rootView: content())
        window.windowLevel = .statusBar + 1 // 기존 뷰 위에 표시
        window.makeKeyAndVisible()
        self.window = window
        
        // 자동으로 사라지도록 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hideNotification()
        }
    }
    
    func hideNotification() {
        window?.isHidden = true
        window = nil
    }
}

// 2. PassthroughWindow 정의
/// 터치 이벤트를 기존 뷰로 전달하는 UIWindow
class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootView = rootViewController?.view,
              let firstSubview = rootView.subviews.first else {
            return nil
        }

        // UIWindow의 좌표를 첫 번째 subview의 좌표로 변환
        let localPoint = convert(point, to: firstSubview)

        // 터치 이벤트가 첫 번째 subview 내부에 있을 경우 해당 뷰 반환
        if firstSubview.bounds.contains(localPoint) {
            debugPrint("???")
            return rootView.hitTest(localPoint, with: event)
        }

        debugPrint("!!!")
        // 첫 번째 subview 외부의 터치는 nil 반환 (기존 뷰로 전달)
        return nil
    }
}

class TransparentHostingController<Content: View>: UIHostingController<Content> {
    
    /// rootView: Generic 타입의 View
    /// view: UIHostingController가 갖는 뷰. view 내부에 rootView가 포함된다. 따라서 이후에 SwiftUI 뷰를 찾고 싶다면 view에 있는 subview를 뒤져야한다.
    override init(rootView: Content) {
          super.init(rootView: rootView)
          view.backgroundColor = .clear
      }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
