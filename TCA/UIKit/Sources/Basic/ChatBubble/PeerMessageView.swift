//
//  PeerChatView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/18/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import Foundation
import UIKit

class PeerMessageView: UITableViewCell {
    private let sendTimeView = UILabel()
    private let messageView = PaddedLabel()
    private let bubbleBackgroundView = UIView()
    
    // 기본 생성자 구현
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpView()
        setUpConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.selectionStyle = .none
        
        addSubview(sendTimeView)
        addSubview(messageView)
        insertSubview(bubbleBackgroundView, belowSubview: messageView)
        
        setUpSendTimeView()
        setUpMessageView()
        setUpBubbleBackgroundView()
    }
    
    func configure(state: MessageState) {
        sendTimeView.text = state.messageSendDate.formatToHourAndMinute(timeZone: .current)
        messageView.text = state.text
    }
    
    private func setUpSendTimeView() {
        sendTimeView.textColor = .gray
        sendTimeView.font = .systemFont(ofSize: 10)
        sendTimeView.lineBreakMode = .byClipping
    }
    
    
    private func setUpMessageView() {
        // 기본 텍스트뷰 속성 설정
        messageView.textColor = .black
        messageView.font = .systemFont(ofSize: 20)
        messageView.backgroundColor = .clear // 기존 배경 제거
        messageView.numberOfLines = 0 // 여러 줄 텍스트 허용
        messageView.sizeToFit()
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
        let bubblePath = BubbleShape(cornerRadius: 10).createPath(in: bubbleBackgroundView.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.fillColor = UIColor(resource: .reppleyGray).cgColor
        
        // 기존 레이어 제거 후 새 레이어 추가
        bubbleBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        bubbleBackgroundView.layer.addSublayer(shapeLayer)
    }
    
    private func setUpConstraints() {
        sendTimeView.snp.makeConstraints { make in
            make.leading.equalTo(messageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-30)
            make.bottom.equalTo(messageView.snp.bottom) // 아래 정렬
        }

        messageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-10).priority(.medium)
            make.trailing.equalTo(sendTimeView.snp.leading).offset(-10).priority(.high)
        }
        
        sendTimeView.setContentCompressionResistancePriority(.required, for: .horizontal)
        sendTimeView.setContentHuggingPriority(.required, for: .horizontal)
        messageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

#Preview {
    ChatViewController(store: Store(initialState: ChatFeature.State(chats: MessageState.stubs), reducer: {
        ChatFeature()
    }))
}
