//
//  CustomNotificationView.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

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

struct CustomNotificationView: View {
    
    @State private var isPreseneted: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Main View")
                    .padding()
                
                Button("Show Notification") {
                    isPreseneted = true
                }
                .notification(isPresented: $isPreseneted) {
                    NotificationView(message: "This is custom notification!")
                }
            }
        }
    }
}

// 7. Preview
#Preview {
    CustomNotificationView()
}
