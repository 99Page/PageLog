//
//  ThumbnailUtilView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import PageKit

/// 이미지 뷰를 사용할 때, 고화질의 ImageResource를 많이 사용하면
/// 프레임이 드랍된다.
/// 특히, 스크롤 하는 경우 UIHang이 많이 발생한다.
/// 이미지 리소스를 사용할 때 이미지를 디코딩 하는 과정에서 메인 쓰레드에 부하가 발생하는 것으로 추측한다.
/// 따라서 디코딩을 백그라운드 쓰레드에서 해주는 것이 관건이다.
/// 아래 예제는 디코딩 + draw를 사용했다. 
final class ImageDecodeView: UIView {
    
    typealias Data = ImageResource
     
    private static let cache = NSCache<NSString, UIImage>()
    private let imageQueue = DispatchQueue(label: "customview.image.decode", qos: .userInitiated)
    private var loadToken = UUID()
    
    required init() {
        super.init(frame: .zero)
    }
    
    private let borderColor = UIColor.randomPastelColor
    private let bgColor = UIColor.randomPastelColor
    private var imageResource: ImageResource?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 과제 step2
        fillBackground(rect)
        
        
        if let imageResource {
            let target = bounds
            let key = makeCacheKey(for: imageResource, size: target.size, scale: UIScreen.main.scale)
            // 과제 step3
            drawCacheImage(key)
            cacheThumbail(key)
        }
        
        // 과제 step4
        applyRoundedStyle()
    }
    
    func configure(image: ImageResource) {
        loadToken = UUID()
        self.imageResource = image
        setNeedsDisplay()
    }
    
    
    private func fillBackground(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(bgColor.cgColor)
        ctx.fill(rect)
    }
    
    private func drawCacheImage(_ cacheKey: NSString) {
        guard let image = Self.cache.object(forKey: cacheKey) else { return }
        let canvas = bounds.size
        let img = image.size
        guard canvas.width > 0, canvas.height > 0, img.width > 0, img.height > 0 else { return }
        
        // Aspect-Fit 계산: 이미지 비율 유지하며 bounds 안에 맞추기
        let scale = min(canvas.width / img.width, canvas.height / img.height)
        let drawW = img.width * scale
        let drawH = img.height * scale
        let originX = bounds.minX + (canvas.width - drawW) * 0.5
        let originY = bounds.minY + (canvas.height - drawH) * 0.5
        
        image.draw(in: CGRect(x: originX, y: originY, width: drawW, height: drawH))
    }
    
    private func cacheThumbail(_ cacheKey: NSString) {
        guard Self.cache.object(forKey: cacheKey) == nil else { return }
        
        removeThumbnail()
        
        let target = bounds
        let currentToken = loadToken
        let data = imageResource
        
        imageQueue.async { [weak self] in
            guard let self else { return }
            guard let data else { return }
            let base = UIImage(resource: data)
            
            // 원본 이미지 사용: jpeg를 비트맵으로 디코딩 필요 -> 프레임 드랍
            // scaledToFit 이후: RGBA 비트맵으로 디코딩 완료 -> 프레임 개선, 메모리 사용 증가.
            let thumb = base.scaledToFit(target.size, scale: UIScreen.main.scale)
            Self.cache.setObject(thumb, forKey: cacheKey)
            
            DispatchQueue.main.async {
                // 셀 재사용 이후 이미지 리렌더 금지
                guard self.loadToken == currentToken else { return }
                self.setNeedsDisplay() // 이 시점에는 CGContext 접근할 수 없어서 setNeedsDisplay 호출 필요.
            }
        }
    }
    
    private func removeThumbnail() {
        layer.contents = nil
    }
    
    private func applyRoundedStyle() {
        layer.cornerRadius = min(bounds.height, bounds.width) / 4
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 4.0
    }
    
    private func makeCacheKey(for data: ImageResource, size: CGSize, scale: CGFloat) -> NSString {
        let w = Int(size.width * scale)
        let h = Int(size.height * scale)
        return NSString(string: "\(data)-\(w)x\(h)@\(Int(scale))")
    }
    
    override var intrinsicContentSize: CGSize {
        let screen = UIScreen.main.bounds.size
        return CGSize(width: screen.width, height: screen.height / 4)
    }
}

private extension UIImage {
    
    /// 이미지의 비율을 유지하면서 축소
    func scaledToFit(_ size: CGSize, scale: CGFloat) -> UIImage {
        guard size.width > 0, size.height > 0 else { return self }
        let originalSizePt = self.size
        guard originalSizePt.width > 0, originalSizePt.height > 0 else { return self }

        let fitSize = calculateAspectFitSize(for: size)
        
        // 이미지 축소만 진행.
        if fitSize.width > originalSizePt.width || fitSize.height > originalSizePt.height {
            return self
        }

        let renderScale = calculateRenderScale(for: fitSize, requestedScale: scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = renderScale
        format.preferredRange = .standard

        let renderer = UIGraphicsImageRenderer(size: fitSize, format: format)
        let output = renderer.image { ctx in
            ctx.cgContext.interpolationQuality = .high
            self.draw(in: CGRect(origin: .zero, size: fitSize))
        }
        
        return output
    }
    
    private func calculateAspectFitSize(for targetSize: CGSize) -> CGSize {
        let boxAspect = targetSize.width / targetSize.height
        let imgAspect = self.size.width / self.size.height
        var result = targetSize
        if boxAspect > imgAspect {
            result.width = targetSize.height * imgAspect
        } else {
            result.height = targetSize.width / imgAspect
        }
        return result
    }
    
    private func calculateRenderScale(for fitSize: CGSize, requestedScale: CGFloat) -> CGFloat {
        let originalWidthPixel = max(Int(round(size.width * self.scale)), self.cgImage?.width ?? 0)
        let originalHeightPixel = max(Int(round(size.height * self.scale)), self.cgImage?.height ?? 0)
        
        let maxWidthScale = CGFloat(originalWidthPixel) / fitSize.width
        let maxHeightScale = CGFloat(originalHeightPixel) / fitSize.height
        let maxScale = max(1, min(maxWidthScale, maxHeightScale)) // 원본보다 커지지 않음
        
        let preferred = min(max(requestedScale, 1), 2) // 품질을 위해 최대 2배까지 제한
        return min(preferred, maxScale)
    }
}

