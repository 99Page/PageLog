//
//  Heap.swift
//  Heap
//
//  Created by 노우영 on 8/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Heap<Element: Comparable> {
    private let comparator: (Element, Element) -> Bool
    var storage: [Element] = []
    
    init(comparator: @escaping (Element, Element) -> Bool) {
        self.comparator = comparator
    }
    
    func peek() -> Element? {
        storage.first
    }
    
    /// - Complexity: O(log n)
    mutating func insert(_ element: Element) {
        storage.append(element)
        let insertedIndex = storage.count - 1
        siftUp(startIndex: insertedIndex)
    }
    
    mutating private func siftUp(startIndex: Int) {
        var currentIndex = startIndex
        
        while hasHigherPriorityThanParent(index: currentIndex) {
            let parentIndex = parentIndex(childIndex: currentIndex)
            storage.swapAt(currentIndex, parentIndex)
            currentIndex = parentIndex
        }
    }
    
    
    private func hasHigherPriorityThanParent(index: Int) -> Bool {
        let parentIndex = parentIndex(childIndex: index)
        let parentElement = storage[parentIndex]
        let childElement = storage[index]
        
        return comparator(childElement, parentElement)
    }
    
    mutating func pop() -> Element? {
        guard !storage.isEmpty else { return nil }
        
        guard storage.count != 1 else { return storage.removeLast()}
        
        let lastIndex = storage.count - 1
        
        storage.swapAt(0, lastIndex)
        let result = storage.removeLast()
        
        siftDown(currentIndex: 0)
        
        return result
    }
    
    private mutating func siftDown(currentIndex: Int) {
        var swapIndex = currentIndex
        var isSwap = false
        let leftIndex = leftChildIndex(parentIndex: currentIndex)
        let rightIndex = rightChildIndex(parentIndex: currentIndex)
        
        if leftIndex < storage.endIndex && comparator(storage[leftIndex], storage[swapIndex]) {
            swapIndex = leftIndex
            isSwap = true
        }
        
        if rightIndex < storage.endIndex && comparator(storage[rightIndex], storage[swapIndex]) {
            swapIndex = rightIndex
            isSwap = true
        }
        
        if isSwap {
            storage.swapAt(swapIndex, currentIndex)
            siftDown(currentIndex: swapIndex)
        }
    }
    
    
    
    
    static func minHeap() -> Self{
        self.init(comparator: <)
    }
    
    static func maxHeap() -> Self{
        self.init(comparator: >)
    }
    
    // MARK: Index 관련 함수들
    func leftChildIndex(parentIndex: Int) -> Int {
        parentIndex * 2 + 1
    }
    
    func rightChildIndex(parentIndex: Int) -> Int {
        parentIndex * 2 + 2
    }
    
    func parentIndex(childIndex: Int) -> Int {
        (childIndex - 1) / 2
    }
}
