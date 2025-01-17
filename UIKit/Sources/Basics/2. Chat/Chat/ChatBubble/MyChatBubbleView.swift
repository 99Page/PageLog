//
//  ChatBubbleView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class MyChatBubbleView: UIView {
    let state: ChatBubbleState
    
    private let sendTimeView = UILabel()
    private let textView = PaddedLabel()
    
    init(state: ChatBubbleState) {
        self.state = state
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(sendTimeView)
        addSubview(textView)
        
        setUpSendTimeView()
        setUpTextView()
    }
    
    private func setUpSendTimeView() {
        sendTimeView.textColor = .gray
        sendTimeView.text = state.sendDate.formatToHourAndMinute(timeZone: .current)
        sendTimeView.font = .systemFont(ofSize: 10)
    }
    
    private func setUpTextView() {
        textView.textColor = .white
        textView.text = state.text
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = UIColor(resource: .reppleyGreen)
        textView.numberOfLines = 0 // 여러 줄 텍스트를 허용
        textView.sizeToFit()
    }
    
    private func setUpConstraints() {
        sendTimeView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(textView.snp.leading).offset(-10)
            make.bottom.equalTo(textView.snp.bottom)
        }
        
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

#Preview {
    MyChatBubbleView(state: ChatBubbleState(text: "Hello", sendDate: .now, isMyMessage: true))
}
