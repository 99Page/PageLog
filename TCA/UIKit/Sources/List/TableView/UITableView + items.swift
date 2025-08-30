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

typealias SectionID = AnyHashableSendable
typealias ItemID = AnyHashableSendable

private struct AssocKeys {
    //  objc_getAssociatedObject에 사용할 key 값들은 모두 동일한 값을 가져야한다
    static var oldItems: UInt8 = 0
    static var dataSource: UInt8 = 0
    static var sectionProvider: UInt8 = 0
}

extension UITableView {
    convenience init<V: SectionProvidable & Equatable>(_ binding: UIBinding<IdentifiedArrayOf<V>>) where V.ID: Hashable {
        self.init()
        
        var oldItems: IdentifiedArrayOf<V> = []
        
        observe { [weak self] in
            guard let self else { return }
            
            let newItems = binding.wrappedValue
            let diffs = PaulHeckel.computeDiff(from: oldItems.elements, to: newItems.elements)
            
            debugPrint(diffs)
            
            for diff in diffs {
                switch diff {
                case .insert(let to):
                    let item = newItems[to]
                    let id = newItems[to].id
                    append(ids: [AnyHashableSendable(id)], to: item.section)
                case .delete(let from):
                    let item = oldItems[from]
                    let id = item.id
                    remove(id: AnyHashableSendable(id))
                case .move(let from, let to):
                    let from = AnyHashableSendable(from)
                    let to = AnyHashableSendable(to)
                    move(from: from, to: to)
                case .update(_, let to):
                    let item = AnyHashableSendable(newItems[to].id)
                    update(item: item)
                }
            }
            
            oldItems = binding.wrappedValue
        }
    }
      
    /// 내부 Diffable Data Source (ID는 AnyHashable로 소거)
    /// `objc_getAssociated`를 활용해서 exntension에서 stored property를 추가할 수 있다
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
    
    func move(from: AnyHashableSendable, to: AnyHashableSendable) {
        guard let ds = diffableDataSource else { return }
        var snapshot = ds.snapshot()
        snapshot.moveItem(from, afterItem: to)
        ds.apply(snapshot)
    }
    
    func update(item: AnyHashableSendable) {
        guard let ds = diffableDataSource else { return }
        var snapshot = ds.snapshot()
        snapshot.reconfigureItems([item])
        ds.apply(snapshot)
    }
    
    func remove(id: AnyHashableSendable) {
        guard let ds = diffableDataSource else { return }
        var snapshot = ds.snapshot()
        snapshot.deleteItems([id])
        ds.apply(snapshot)
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
