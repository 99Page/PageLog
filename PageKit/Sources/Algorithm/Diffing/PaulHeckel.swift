//
//  PaulHeckel.swift
//  PageKit
//
//  Created by Reppley_iOS on 4/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct PaulHeckel<Item: Hashable & Identifiable> {
    
    typealias ItemMap = [Item.ID: Int]
    typealias Move = (from: Int, to: Int)
    
    var oldResult: [Item] = []
    
    struct DiffResult {
        var insertions: [Int] = []
        var deletions: [Int] = []
        var moves: [Move] = []
    }
    
    mutating func changeItems(_ items: [Item]) -> DiffResult {
        let result = diff(items)
        self.oldResult = items
        return result
    }
    
    func diff(_ newItems: [Item]) -> DiffResult {
        var result = DiffResult()
        
        let oldItemMap: ItemMap = makeItemMap(oldResult)
        let newItemMap: ItemMap = makeItemMap(newItems)
        
        result.deletions = findDeletedItems(old: oldItemMap, new: newItemMap)
        result.insertions = findInsertedItems(old: oldItemMap, new: newItemMap)
        result.moves = findMovedItems(old: oldItemMap, new: newItemMap)
        
        return result
    }
    
    func findInsertedItems(old: ItemMap, new: ItemMap) -> [Int] {
        var result: [Int] = []
        
        for (id, newIndex) in new {
            if old[id] == nil { result.append(newIndex) }
        }
        
        return result
    }
    
    private func findMovedItems(old: ItemMap, new: ItemMap) -> [Move] {
        var result: [Move] = []
        
        for id in old.keys {
            if let oldIndex = old[id], let newIndex = new[id], oldIndex != newIndex {
                result.append(Move(from: oldIndex, to: newIndex))
            }
        }
        
        return result
    }
    
    private func findDeletedItems(old: ItemMap, new: ItemMap) -> [Int] {
        var result: [Int] = []
        
        for (id, oldIndex) in old {
            if new[id] == nil { result.append(oldIndex) }
        }
        
        return result
    }
    
    private func makeItemMap(_ items: [Item]) -> ItemMap {
        var result: [Item.ID: Int] = [:]
        
        for (index, item) in items.enumerated() {
            result[item.id] = index
        }
        
        return result
    }
}
