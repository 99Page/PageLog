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
    private(set) var elements: [Element] = []
    
    init(comparator: @escaping (Element, Element) -> Bool) {
        self.comparator = comparator
    }
    
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    func peek() -> Element? {
        elements.first
    }
    
    /// - Complexity: O(log n)
    mutating func insert(_ element: Element) {
        elements.append(element)
        let insertedIndex = elements.count - 1
        siftUp(startIndex: insertedIndex)
    }
    
    mutating private func siftUp(startIndex: Int) {
        var currentIndex = startIndex
        
        while hasHigherPriorityThanParent(index: currentIndex) {
            let parentIndex = parentIndex(childIndex: currentIndex)
            elements.swapAt(currentIndex, parentIndex)
            currentIndex = parentIndex
        }
    }
    
    
    private func hasHigherPriorityThanParent(index: Int) -> Bool {
        guard index < elements.endIndex else { return false }
        
        let parentIndex = parentIndex(childIndex: index)
        let parentElement = elements[parentIndex]
        let childElement = elements[index]
        
        return comparator(childElement, parentElement)
    }
    
    mutating func pop() -> Element? {
        guard !elements.isEmpty else { return nil }
        
        guard elements.count != 1 else { return elements.removeLast()}
        
        let lastIndex = elements.count - 1
        
        elements.swapAt(0, lastIndex)
        let result = elements.removeLast()
        
        siftDown(currentIndex: 0)
        
        return result
    }
    
    private mutating func siftDown(currentIndex: Int) {
        var swapIndex = currentIndex
        var isSwap = false
        let leftIndex = leftChildIndex(parentIndex: currentIndex)
        let rightIndex = rightChildIndex(parentIndex: currentIndex)
        
        if hasHigherPriorityThanParent(index: leftIndex) {
            swapIndex = leftIndex
            isSwap = true
        }
        
        if rightIndex < elements.endIndex && comparator(elements[rightIndex], elements[swapIndex]) {
            swapIndex = rightIndex
            isSwap = true
        }
        
        if isSwap {
            elements.swapAt(swapIndex, currentIndex)
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
    private func leftChildIndex(parentIndex: Int) -> Int {
        parentIndex * 2 + 1
    }
    
    private func rightChildIndex(parentIndex: Int) -> Int {
        parentIndex * 2 + 2
    }
    
    private func parentIndex(childIndex: Int) -> Int {
        (childIndex - 1) / 2
    }
}
