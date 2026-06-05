//
//  ImageCellView.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 8/27/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SnapKit
import SwiftUI
import UIKit

/// UIView 만들고, 이 뷰를 CellView에 추가
/// 뷰를 한번 만들고, 다른 뷰 / CollectionCellView, TableCellView에도 사용할 수 있고
/// 프리뷰 사용이 가능해진다
///
/// CellView는 프리뷰에서 확인하기가 어렵다.
class ImageCellView: UIView {
    
    @UIBinding var item: ImageItem? = ImageItem.bear
    
    var observeToken: ObserveToken?
    
    private let imageView = UIImageView(frame: .zero)
    private let label = UILabel()
    private let colorCircleView = UIView()
    
    init() {
        super.init(frame: .zero)
        setupView()
        makeConstraints()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        colorCircleView.layer.cornerRadius = 25
        colorCircleView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCircleTap))
        colorCircleView.addGestureRecognizer(tap)
    }
    
    private func makeConstraints() {
        addSubview(imageView)
        addSubview(label)
        addSubview(colorCircleView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        colorCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    func binding(_ item: UIBinding<ImageItem?>) {
        self._item = item
        updateView()
    }
    
    private func updateView() {
        observeToken = observe { [weak self] in
            guard let self else { return }
            guard let item else { return }
            
            imageView.image = UIImage(resource: item.image)
            label.text = item.name
            
            let color = item.color
            
            UIView.animate(withDuration: 0.25) {
                self.colorCircleView.backgroundColor = UIColor(resource: color)
            }
        }
    }
    
    @objc private func handleCircleTap() {
        item?.color = ImageItem.colorCandidates.randomElement() ?? .bubblegum
    }
}

class ImageTableViewCell: UITableViewCell {
    private let view = ImageCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: UIBinding<ImageItem?>) {
        view.binding(item)
    }
    
    private func makeConstraints() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.observeToken?.cancel()
        view.observeToken = nil
    }
}

#Preview {
    ViewPreview(fromY: \.centerY, toY: \.centerY) {
        ImageCellView()
    }
    .padding(.horizontal, 20)
}
