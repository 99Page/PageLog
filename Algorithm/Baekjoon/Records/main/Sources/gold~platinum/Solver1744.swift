//
//  Solver1744.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1744 {
    var maxHeap = Heap<Int>.maxHeap()
    var minHeap = Heap<Int>.minHeap()
    let n: Int


    var result: Int = 0

    
    init() {
        self.n = readInteger()
    }
    
    mutating func solve() {
        insertValues()
        findMaxSum()
        print(result)
    }

    mutating func findMaxSum() {
        addValuesInMaxHeap()
        addValuesInMinHeap()
    }

    mutating func addValuesInMinHeap() {
        guard !minHeap.storage.isEmpty else { return }
        
        var oldValue = minHeap.pop()!
        var isOddSequence: Bool = false
        
        while !minHeap.storage.isEmpty {
            let newValue = minHeap.pop()!
            
            if !isOddSequence {
                result += oldValue * newValue
            }
            
            oldValue = newValue
            isOddSequence.toggle()
        }
        
        /// 홀수번째에 있는 수가 더해지지 않은 경우입니다.
        if !isOddSequence {
            result += oldValue
        }
    }

    mutating func addValuesInMaxHeap() {
        guard !maxHeap.storage.isEmpty else { return }
        
        var oldValue = maxHeap.pop()!
        var isOddSequence: Bool = false
        
        while !maxHeap.storage.isEmpty {
            let newValue = maxHeap.pop()!
            
            if !isOddSequence {
                result += max(oldValue * newValue, oldValue + newValue)
            }
            
            oldValue = newValue
            isOddSequence.toggle()
        }
        
        /// 홀수번째에 있는 수가 더해지지 않은 경우입니다.
        if !isOddSequence {
            result += oldValue
        }
    }


    mutating func insertValues() {
        for _ in 0..<n {
            let value = readInteger()
            if value > 0 {
                maxHeap.insert(value)
            } else {
                minHeap.insert(value)
            }
        }
    }

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
            guard index < storage.endIndex else { return false }
            
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
            
            if hasHigherPriorityThanParent(index: leftIndex) {
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

}

private func readInteger() -> Int {
    let input = readLine()!
    return Int(input)!
}

