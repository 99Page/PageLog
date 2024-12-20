//
//  CustomNotificationView.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

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
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(.bottom, 20) // 아래 여백
        }
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.5), value: true)
    }
}

// 6. ContentView에서 사용
struct CustomNotificationView: View {
    
    @State private var isPreseneted: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                Button("show") {
                    isPreseneted = true
                }
                .fullScreenCover(isPresented: $isPreseneted) {
                    Color.red
                }
                
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
