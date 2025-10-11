//
//  ImageViewWrapper.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/10/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

private var imageTaskKey: Void?
private var imageLoaderKey: Void?

protocol ImageSettable: AnyObject { }

extension UIImageView: ImageSettable { }

struct ImageViewWrapper<Base> {
    let base: Base
    
    init(base: Base) {
        self.base = base
    }
}

extension ImageViewWrapper {
    // struct에는 getAssociatedObject 사용할 수 없다.
    // struct에 어떤 class를 참조 시키고,
    // 이 class에 extension 해주면
    // associatedObject 활용이 가능하기때문에
    // stored property처럼 이용 가능하다.
    var loader: (any LoadImageHandler) {
        get { getAssociatedObject(base, &imageLoaderKey) ?? ImageLoaderFactory.makeHandler() }
        set { setRetainedAssociatedObject(base, &imageLoaderKey, newValue) }
    }
    
    var imageTask: Task<Void, any Error>? {
        get { getAssociatedObject(base, &imageTaskKey) }
        set { setRetainedAssociatedObject(base, &imageTaskKey, newValue)}
    }
}
    
extension ImageSettable {
    // 캐싱/로드 기능을 사용하기 위한 entry point
    // 이런 entry point는 class에만 적용 가능
    var loadEP: ImageViewWrapper<Self> {
        get { return ImageViewWrapper(base: self) }
        set { }
    }
}

extension ImageViewWrapper where Base: UIImageView {
    func setImage(from url: String) {
        var copiedSelf = self
        
        let task = Task {
            let startTime = CFAbsoluteTimeGetCurrent()
            let image = try await loader.loadImage(fromKey: url)
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            UIKitLogger.logDebug("Image load duration: \(duration) seconds")
            await MainActor.run {
                base.image = UIImage(data: image)
            }
            
            copiedSelf.imageTask = nil
        }
        
        copiedSelf.imageTask = task
    }
    
    func cancelDownload() {
        imageTask?.cancel()
    }
    
    // extension에 추가한 computedProperty를 추가하는 예제 코드
    func setLoader(_ loader: any LoadImageHandler) {
        // imageViewWrapper에서 mutating func를 사용할 수는 없다.
        // 따라서 mutatingSelf를 사용해서, value를 copy하고 여기에 있는 레퍼런스를 변경한다.
        // mutatingSelf 내부에 있는 값에 접근하면 이건 self에 있는 값에 접근하는 것과 동일하다.
        var mutatingSelf = self
        mutatingSelf.loader = loader
    }
}

private func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    if #available(iOS 14, macOS 11, watchOS 7, tvOS 14, *) { // swift 5.3 fixed this issue (https://github.com/swiftlang/swift/issues/46456)
        return objc_getAssociatedObject(object, key) as? T
    } else {
        return objc_getAssociatedObject(object, key) as AnyObject as? T
    }
}

private func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
