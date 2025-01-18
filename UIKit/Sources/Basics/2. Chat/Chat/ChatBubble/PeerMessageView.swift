//
//  PeerChatView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/18/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class PeerMessageView: UIView {
    let state: MessageState
    
    private let sendTimeView = UILabel()
    private let messageView = PaddedLabel()
    private let bubbleBackgroundView = UIView()
    
    init(state: MessageState) {
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
        addSubview(messageView)
        insertSubview(bubbleBackgroundView, belowSubview: messageView)
        
        setUpSendTimeView()
        setUpMessageView()
        setUpBubbleBackgroundView()
    }
    
    private func setUpSendTimeView() {
        sendTimeView.textColor = .gray
        sendTimeView.text = state.messageSendDate.formatToHourAndMinute(timeZone: .current)
        sendTimeView.font = .systemFont(ofSize: 10)
    }
    
    
    private func setUpMessageView() {
        // 기본 텍스트뷰 속성 설정
        messageView.textColor = .black
        messageView.text = state.text
        messageView.font = .systemFont(ofSize: 20)
        messageView.backgroundColor = .clear // 기존 배경 제거
        messageView.numberOfLines = 0 // 여러 줄 텍스트 허용
    }
    
    private func setUpBubbleBackgroundView() {
        bubbleBackgroundView.backgroundColor = .clear // 투명 배경
        bubbleBackgroundView.isUserInteractionEnabled = false // 터치 이벤트 방지
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // bubbleBackgroundView의 프레임 업데이트
        bubbleBackgroundView.frame = messageView.frame.insetBy(dx: 0, dy: 0)
        
        // Bubble 모양 생성
        let cornerRadius = state.backgroundCornerRadius
        let bubblePath = BubbleShape(cornerRadius: cornerRadius).createPath(in: bubbleBackgroundView.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.fillColor = UIColor(resource: .reppleyGray).cgColor
        
        // 기존 레이어 제거 후 새 레이어 추가
        bubbleBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        bubbleBackgroundView.layer.addSublayer(shapeLayer)
    }
    
    private func setUpConstraints() {
        sendTimeView.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview().offset(-state.dateViewOffset)
            make.leading.equalTo(messageView.snp.trailing).offset(state.messageViewOffset)
            make.bottom.equalTo(messageView.snp.bottom)
        }

        
        messageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
}

#Preview("Long Text") {
    let state = MessageState(
        text: "Imagine there's no heaven. It's easy if you tryNo hell below us Above us, only sky Imagine all the people Living for today",
        messageSendDate: .now,
        isMyMessage: false
    )
    
    PeerMessageView(state: state)
}
