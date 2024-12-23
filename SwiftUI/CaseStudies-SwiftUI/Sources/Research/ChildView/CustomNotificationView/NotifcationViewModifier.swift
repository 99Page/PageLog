//
//  NotifcationViewModifier.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// View에 알림(Notification)을 표시하는 메서드를 제공합니다.
extension View {
    /// 뷰 위에 일정 시간 동안 표시되는 알림을 보여줍니다.
    /// - Parameters:
    ///   - isPresented: 알림 표시 여부를 제어하는 바인딩 값입니다.
    ///   - duration: 알림이 자동으로 사라지는 데 걸리는 시간(초)입니다. 기본값은 3초입니다.
    ///   - content: 알림으로 표시할 뷰입니다.
    /// - Returns: 원본 뷰에 알림 기능이 적용된 View를 반환합니다.
    func notification<Content: View>(
        isPresented: Binding<Bool>,
        duration: TimeInterval = 3,
        content: @escaping () -> Content
    ) -> some View {
        self
            .modifier(
                NotificationViewModifier(
                    isPresented: isPresented,
                    duration: duration,
                    view: content
                )
            )
    }
}

/// 알림(Notification)을 화면에 표시하기 위한 ViewModifier입니다.
struct NotificationViewModifier<T: View>: ViewModifier {
    /// 알림의 표시 여부를 제어하는 바인딩 값입니다.
    @Binding var isPresented: Bool

    /// 알림에 표시될 뷰를 생성하는 클로저입니다.
    var view: () -> T
    
    /// 알림을 보여주고 숨기기 위한 OverlayWindow 입니다.
    let overlayWindow: OverlayWindow

    /// 알림이 자동으로 사라지는 데 걸리는 시간(초)입니다.
    let duration: TimeInterval

    /// NotificationViewModifier를 초기화합니다.
    /// - Parameters:
    ///   - isPresented: 알림 표시 여부를 제어하는 바인딩 값입니다.
    ///   - duration: 알림이 자동으로 사라지는 데 걸리는 시간(초)입니다. 기본값은 3초입니다.
    ///   - view: 알림에 표시될 뷰를 생성하는 클로저입니다.
    init(isPresented: Binding<Bool>,
         duration: TimeInterval = 3,
         view: @escaping () -> T) {
        self._isPresented = isPresented
        self.duration = duration
        self.view = view
        self.overlayWindow = OverlayWindow(isPresented: isPresented)
    }

    /// 원본 콘텐츠에 알림 표시 기능을 적용합니다.
    /// - Parameter content: 수정 대상 View(원본 콘텐츠)입니다.
    /// - Returns: 알림 표시 기능이 적용된 View를 반환합니다.
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue {
                    overlayWindow.showNotification(duration: duration) {
                        view()
                            .onTapGesture {
                                isPresented = false
                            }
                    }
                } else {
                    overlayWindow.hideAllNotifications()
                }
            }
    }
}
