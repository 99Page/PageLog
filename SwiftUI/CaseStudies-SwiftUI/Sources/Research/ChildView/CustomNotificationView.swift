//
//  CustomNotificationView.swift
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
        window.backgroundColor = .clear // UIWindow를 투명하게 설정
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
        // Notification 외의 터치 이벤트는 기존 뷰로 전달
        let hitView = super.hitTest(point, with: event)
         if let hostingView = rootViewController?.view, hitView === hostingView {
             return nil // Notification View 외부는 터치를 아래로 전달
         }
         return hitView
    }
}

// 3. TransparentHostingController 정의
/// SwiftUI 뷰를 투명하게 표시하기 위한 UIHostingController
class TransparentHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}

// 4. View Extension으로 간편한 호출 지원
extension View {
    func showNotification(message: String, duration: TimeInterval = 3) {
        let overlayWindow = OverlayWindow()
        overlayWindow.showNotification {
            NotificationView(message: message)
                .onTapGesture {
                    overlayWindow.hideNotification()
                }
        }
    }
}

// 5. Notification View 정의
struct NotificationView: View {
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        }
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.5), value: true)
    }
}

// 6. ContentView에서 사용
struct CustomNotificationView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Main View")
                    .padding()
                
                Button("Show Notification") {
                    self.showNotification(message: "This is a custom notification!")
                }
            }
        }
    }
}

// 7. Preview
#Preview {
    CustomNotificationView()
}
