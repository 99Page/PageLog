//
//  ToggleCell.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftNavigation


/// ToggleCell의 상태값
struct ToggleState: Identifiable, Equatable {
    let id = UUID()
    var isOn: Bool = false
    var color: UIColor = .red
}

class ToggleCell: UITableViewCell {
    
    private let label = UILabel()
    private let toggleBackground = UIView()
    private let toggle = UIView()
    
    var state: UIBinding<ToggleState>?
    private var observer: ObserveToken?
    
    // 기본 생성자 구현
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        makeConstraints()
    }
    
    private func setupView() {
        label.text = "텍스트"
        toggleBackground.layer.cornerRadius = 15
        toggleBackground.backgroundColor = .gray
        setupToggle()
    }
    
    private func setupToggle() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleToggleButtonAction)
        )
        
        toggle.addGestureRecognizer(tapGesture)
        toggle.isUserInteractionEnabled = true
        toggle.layer.cornerRadius = 14
        toggle.backgroundColor = .green
    }
    
    private func makeConstraints() {
        
        // contentView에 추가해줘야한다.
        // 안그러면 버튼 상호작용이나 레이아웃 같은 문제가 발생한다.
        contentView.addSubview(label)
        contentView.addSubview(toggleBackground)
        contentView.addSubview(toggle)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        toggleBackground.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(label)
        }
        
        toggle.snp.makeConstraints { make in
            make.leading.equalTo(toggleBackground).offset(1)
            make.centerY.equalTo(toggleBackground)
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ binding: UIBinding<ToggleState>) {
        self.state = binding
        updateView()
    }
    
    private func updateView() {
        observer = observe { [weak self] in
            guard let self else { return }
            guard let state else { return }
            
            
            label.textColor = state.color.wrappedValue
            
            if state.isOn.wrappedValue {
                moveToggleToLeading()
            } else {
                moveToggleToTrailing()
            }
        }
    }
    
    private func moveToggleToLeading() {
        // 제약 조건을 다시 걸땐 remake를 사용한다.
        toggle.snp.remakeConstraints { make in
            make.leading.equalTo(self.toggleBackground).offset(1)
            make.centerY.equalTo(self.toggleBackground)
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
    }
    
    private func moveToggleToTrailing() {
        // 제약 조건을 다시 걸땐 remake를 사용한다.
        toggle.snp.remakeConstraints { make in
            make.trailing.equalTo(self.toggleBackground).offset(-1)
            make.centerY.equalTo(self.toggleBackground)
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        state = nil
        observer = nil
    }
    
    @objc private func handleToggleButtonAction() {
        let colorCandidates: [UIColor] = [.red, .blue, .green, .yellow, .orange, .cyan]
        
        state?.color.wrappedValue = colorCandidates.randomElement() ?? .black
        state?.isOn.wrappedValue.toggle()
    }
}

#Preview {
    @Previewable @UIBinding
    var state = ToggleState(isOn: true, color: .blue)
    
    let toggleCell = ToggleCell()
    toggleCell.configure($state)
    
    return VStack {
        UIViewPreview {
            toggleCell
        }
        .background(Color.blue.opacity(0.5))
        .frame(width: 200, height: 100)
    }
}
