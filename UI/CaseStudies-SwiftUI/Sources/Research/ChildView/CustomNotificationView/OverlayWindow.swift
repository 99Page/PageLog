//
//  OverlayWindow.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import UIKit

class OverlayWindow {
    /// 오버레이용 UIWindow 인스턴스입니다. 알림 표시를 위한 별도의 윈도우를 생성합니다.
    private var window: UIWindow?
    
    /// 오버레이 윈도우의 표시 상태를 나타내는 Binding입니다.
    var isPresented: Binding<Bool>
    
    /// 숨겨야 할 알림의 식별자 목록입니다.
    var hideIds: Set<String> = []
    
    /// 오버레이 윈도우 객체를 생성합니다.
    /// - Parameter isPresented: 오버레이 윈도우의 표시 여부를 제어하는 Binding입니다.
    init(isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
    
    /// 지정한 콘텐츠를 알림 형태로 화면에 표시합니다.
    /// - Parameters:
    ///   - content: 알림에 표시할 뷰 콘텐츠입니다.
    ///   - duration: 알림이 자동으로 사라지기까지의 시간(초)입니다. 기본값은 3초입니다.
    func showNotification<Content: View>(@ViewBuilder content: () -> Content,
                                         duration: TimeInterval = 3) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let window = PassthroughWindow(windowScene: scene)
        window.rootViewController = TransparentHostingController(rootView: content())
        window.windowLevel = .statusBar + 1
        window.makeKeyAndVisible()
        self.window = window
        
        let id = UUID().uuidString
        hideIds.insert(id)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hideNotification(id: id)
        }
    }
    
    /// 현재 표시된 모든 알림을 숨깁니다.
    func hideAllNotifications() {
        hideIds.removeAll()
        window?.isHidden = true
        window = nil
        isPresented.wrappedValue = false
    }
    
    /// 지정한 식별자를 갖는 알림을 숨깁니다.
    /// - Parameter id: 숨길 알림의 고유 식별자입니다.
    func hideNotification(id: String) {
        guard hideIds.contains(id) else { return }
        
        hideIds.remove(id)
        
        isPresented.wrappedValue = false
        window?.isHidden = true
        window = nil
    }
}

/// SwiftUI 뷰가 추가된 영역을 제외한 곳의 event를 무시하기 위한 UIWindow
///
/// ## UIWindow란?
/// RootViewController에 의해 제어되는 여러 뷰를 갖는 앱의 기본 구성 요소. 다음의 상황에서 사용할 수 있다. 디바이스에 z축으로 뷰를 구성할 때 유용하다.
///
///
/// ## Reference
/// [UIWindow](https://developer.apple.com/documentation/uikit/uiwindow)
class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // rootView: ``TransparentHostingController`` 에서 초기화한 `rootView`와 동일한 뷰.
        guard let view = rootViewController?.view,
              let rootView = view.subviews.first else {
            return nil
        }
        
        
        // 상호작용이 가능한 영역
        let hitPoint = convert(point, to: rootView)
        
        if view.bounds.contains(hitPoint) {
            return view.hitTest(hitPoint, with: event)
        } else {
            // NotificationView를 제외한 나머지 영역은 상호작용 불가능.
            // 아래 있는 윈도우로 상호작용을 넘김
            return nil
        }
    }
}

/// SwiftUI 뷰를 추가시키며 뒤의 영역을 투명하게 만드는 ViewController
///
/// ## UIHostringController란?
///
/// SwiftUI 뷰를 UIKit 뷰 계층에 포함시키고 싶을 때 사용하는 타입.
/// 주어진 뷰를 RootViewController의 RootView로 사용한다.
///
/// ## UIViewController란?
/// UIViewController는  다음의 기능을 한다.
///
/// 1. 사용자 상호작용에 응답.
/// 2. 인터페이스 관리
/// 3. 다른 뷰 컨트롤러와 상호작용
/// 4. 데이터 변경에 따른 뷰 업데이트
///
/// ## Reference
/// [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)
/// [UIHostingContoller](https://www.google.com/search?client=safari&rls=en&q=UIHostringController&ie=UTF-8&oe=UTF-8&safe=active)
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
