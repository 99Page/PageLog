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
    static var dataSource: UInt8 = 0
    static var sectionProvider: UInt8 = 0
}

extension UITableView {
    convenience init<V: SectionProvidable>(_ binding: UIBinding<IdentifiedArrayOf<V>>) where V.ID: Hashable {
        self.init()
        
        observe { [weak self] in
            guard let self else { return }
            streamEvent(newItem: binding.wrappedValue.elements)
            self.oldItems = binding.wrappedValue.elements.map(\.id).map(AnyHashableSendable.init)
        }
    }
    
    func streamEvent<V: SectionProvidable & Identifiable>(newItem: [V]) {
        if let newLast = newItem.last, oldItems.last != AnyHashableSendable(newLast.id) {
            append(ids: [AnyHashableSendable(newLast.id)], to: newLast.section)
        }
    }
    
    var oldItems: [AnyHashableSendable] {
        get { objc_getAssociatedObject(self, &AssocKeys.oldItems) as? [AnyHashableSendable] ?? [] }
        set { objc_setAssociatedObject(self, &AssocKeys.oldItems, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 내부 Diffable Data Source (ID는 AnyHashable로 소거)
    var diffableDataSource: UITableViewDiffableDataSource<AnyHashableSendable, AnyHashableSendable>? {
        get { objc_getAssociatedObject(self, &AssocKeys.dataSource) as? UITableViewDiffableDataSource<AnyHashableSendable, AnyHashableSendable> }
        set { objc_setAssociatedObject(self, &AssocKeys.dataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Diffable Data Source 구성 (셀 공급자: AnyHashable ID 사용)
    func configureDiffable(cellProvider: @escaping (UITableView, IndexPath, AnyHashableSendable) -> UITableViewCell?) {
        let ds = UITableViewDiffableDataSource<AnyHashableSendable, AnyHashableSendable>(tableView: self) { tv, indexPath, anyID in
            return cellProvider(tv, indexPath, anyID)
        }
        
        self.diffableDataSource = ds
        self.dataSource = ds
    }
    
    func append<S: Hashable>(ids: [AnyHashableSendable], to section: S, animating: Bool = true) {
        guard let ds = diffableDataSource else { return }
        var snapshot = ds.snapshot()
        
        let sections = snapshot.sectionIdentifiers
        let section = AnyHashableSendable(section)
        
        for id in ids {
            if !sections.contains(section) {
                snapshot.appendSections([section])
            }
            snapshot.appendItems([id], toSection: section)
        }
        
        ds.apply(snapshot, animatingDifferences: animating)
    }
}

typealias SectionID = AnyHashableSendable
typealias ItemID = AnyHashableSendable
