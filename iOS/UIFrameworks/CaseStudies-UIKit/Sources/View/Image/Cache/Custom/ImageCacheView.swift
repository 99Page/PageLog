//
//  ImageCacheView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto
import SnapKit

/// 외부 라이브러리 없이 URL로부터 이미지를 불러오고 캐싱하는 간단한 UIImageView 서브클래스입니다.
final class ImageCacheView: UIView {
    var loadImageHandler: any LoadImageHandler
    
    private let imageView = UIImageView()
    
    init(loadImageHandler: any LoadImageHandler) {
        self.loadImageHandler = loadImageHandler
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        makeConstraints()
        setupViews()
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
    }
    
    private func makeConstraints() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadImage(fromKey key: String) {
        Task {
            do {
                let startTime = CFAbsoluteTimeGetCurrent()
                let image = try await loadImageHandler.loadImage(fromKey: key)
                imageView.image = image
                let endTime = CFAbsoluteTimeGetCurrent()
                let duration = endTime - startTime
                UIKitLogger.logDebug("Image load duration: \(duration) seconds")
            } catch {
                UIKitLogger.logDebug("image load fail")
            }
        }
    }
    
    func reloadImage(fromKey key: String) {
        imageView.image = nil
        loadImage(fromKey: key)
    }
}
