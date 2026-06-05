//
//  KeyboardViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class KeyboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addKeyboardObserver() {
        // iOS 26 이상부터 하드웨어 이벤트의 일부는 강타입(strong type)으로 변경 됐습니다.
        // 또한, 이전의 API는 deprecated 됩니다.
        // reference: https://developer.apple.com/videos/play/wwdc2025/243/?time=1238
        // -page, 2025. 06. 22
        if #available(iOS 26.0, *) {
            let _ = NotificationCenter.default.addObserver(of: UIScreen.self, for: .keyboardWillShow) { message in
                UIKitLogger.logDebug("Keyboard will show", category: "Keyboard")
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleKeyboardWillShow(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        }
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIKitLogger.logDebug("Keyboard will show", category: "Keyboard")
        }
    }
}
