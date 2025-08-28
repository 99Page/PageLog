//
//  UITableView + items.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 8/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit

private struct AssocKeys {
  static var oldItems: UInt8 = 0
  static var snapshotEvent: UInt8 = 0
  static var snapshotHandler: UInt8 = 0
}

extension UITableView {
    convenience init<V>(_ binding: UIBinding<IdentifiedArrayOf<V>>) where V.ID == String {
        self.init()
        
        observe { [weak self] in
            guard let self else { return }
            let newItems = binding.wrappedValue.elements.map(\.id)
            streamEvent(newItem: newItems)
            self.oldItems = newItems
        }
    }
    
    func streamEvent(newItem: [String]) {
        if let newLast = newItem.last, oldItems.last != newLast {
            self.snapshotHandler(.append([newLast]))
        }
    }
    
    var oldItems: [String] {
      get { objc_getAssociatedObject(self, &AssocKeys.oldItems) as? [String] ?? [] }
      set { objc_setAssociatedObject(self, &AssocKeys.oldItems, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var snapshotHandler: (SnapshotEvent) -> Void {
        get {
            (objc_getAssociatedObject(self, &AssocKeys.snapshotHandler) as? (SnapshotEvent) -> Void) ?? { _ in }
        }
        set {
            objc_setAssociatedObject(self, &AssocKeys.snapshotHandler, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    enum SnapshotEvent: Equatable {
        case append([String])
        case reconfigure([String])
        case none
    }
}
