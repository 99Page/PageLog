//
//  ChatBubbleView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class MyChatView: UIView {
    let state: ChatState
    
    private let sendTimeView = UILabel()
    private let textView = PaddedLabel()
    private let bubbleBackgroundView = UIView()
    
    init(state: ChatState) {
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
        insertSubview(bubbleBackgroundView, belowSubview: textView)
        
        setUpSendTimeView()
        setUpTextView()
        setUpBubbleBackgroundView()
    }
    
    private func setUpSendTimeView() {
        sendTimeView.textColor = .gray
        sendTimeView.text = state.sendDate.formatToHourAndMinute(timeZone: .current)
        sendTimeView.font = .systemFont(ofSize: 10)
    }
    
    
    private func setUpTextView() {
        // 기본 텍스트뷰 속성 설정
        textView.textColor = .white
        textView.text = state.text
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = .clear // 기존 배경 제거
        textView.numberOfLines = 0 // 여러 줄 텍스트 허용
        textView.textAlignment = .right
    }
    
    private func setUpBubbleBackgroundView() {
        bubbleBackgroundView.backgroundColor = .clear // 투명 배경
        bubbleBackgroundView.isUserInteractionEnabled = false // 터치 이벤트 방지
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // bubbleBackgroundView의 프레임 업데이트
        bubbleBackgroundView.frame = textView.frame.insetBy(dx: 0, dy: 0)
        
        // Bubble 모양 생성
        let bubblePath = BubbleShape(cornerRadius: 10).createPath(in: bubbleBackgroundView.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.fillColor = UIColor(resource: .reppleyGreen).cgColor
        
        // 기존 레이어 제거 후 새 레이어 추가
        bubbleBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        bubbleBackgroundView.layer.addSublayer(shapeLayer)
    }
    
    private func setUpConstraints() {
        sendTimeView.snp.makeConstraints { make in
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
    MyChatView(state: ChatState(text: "Hello", sendDate: .now, isMyMessage: true))
}
