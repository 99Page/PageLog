//
//  Solver7662.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver7662 {
    var minHeap = Heap<Int>.minHeap()
    var maxHeap = Heap<Int>.maxHeap()

    /// Key: 각 힙에서 pop된 값의 개수
    /// Value: 개수
    var maxPopDictionary: [Int: Int] = [:]
    var minPopDictionary: [Int: Int] = [:]

    let t: Int
    
    init() {
        self.t = readIntValue()
    }

    mutating func executeDualPriorityQueueSeveralTimes() {
        for _ in 0..<t{
            executeDualPriorityQueue()
            
            minHeap.storage.removeAll()
            maxHeap.storage.removeAll()
            maxPopDictionary.removeAll()
            minPopDictionary.removeAll()
        }
    }

    mutating func executeDualPriorityQueue() {
        let k = readIntValue()
        
        for _ in 0..<k {
           let (operation, value) = readOperationAndValue()
            handleOperations(operation: operation, value: value)
        }
        
        
        let minValue = popInMinHeap()
        
        if minValue != nil {
            maxHeap.insert(minValue!)
        }
        
        let maxValue = popInMaxHeap()
        
        if minValue == nil || maxValue == nil {
            print("EMPTY")
        } else {
            print("\(maxValue!) \(minValue!)")
        }
    }

    mutating func handleOperations(operation: String, value: Int) {
        switch operation {
        case "I":
            minHeap.insert(value)
            maxHeap.insert(value)
        case "D":
            pop(value: value)
        default:
            break
        }
    }

    mutating func pop(value: Int) {
        switch value {
        case 1:
            popInMaxHeap()
        case -1:
            popInMinHeap()
        default:
            break
        }
    }

    @discardableResult
    mutating func popInMinHeap() -> Int? {
        var minValue = minHeap.pop()
        
        while minValue != nil {
            /// maxHeap에서 뺀 값이 아닌 경우
            if maxPopDictionary[minValue!] == nil || maxPopDictionary[minValue!] == 0 {
                let newValue = (minPopDictionary[minValue!] ?? 0) + 1
                minPopDictionary.updateValue(newValue, forKey: minValue!)
                return minValue
            } else { /// maxHeap에서 이미 뺀 값인 경우
                maxPopDictionary[minValue!]! -= 1
                minValue = minHeap.pop()
            }
        }
        
        maxHeap.storage.removeAll()
        maxPopDictionary.removeAll()
        minPopDictionary.removeAll()
        return minValue
    }


    @discardableResult
    mutating func popInMaxHeap() -> Int? {
        var maxValue = maxHeap.pop()
        
        while maxValue != nil {
            if minPopDictionary[maxValue!] == nil || minPopDictionary[maxValue!] == 0 {
                let newValue = (maxPopDictionary[maxValue!] ?? 0) + 1
                maxPopDictionary.updateValue(newValue, forKey: maxValue!)
                return maxValue
            } else {
                minPopDictionary[maxValue!]! -= 1
                maxValue = maxHeap.pop()
            }
        }
        
        minHeap.storage.removeAll()
        maxPopDictionary.removeAll()
        minPopDictionary.removeAll()
        return maxValue
    }

    func readOperationAndValue() -> (String, Int) {
        let input = readLine()!
        let splitedInput = input.split(separator: " ")
        
        let opereation = String(splitedInput[0])
        let value = Int(splitedInput[1])!
        
        return (opereation, value)
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
}

private func readIntValue() -> Int {
    let input = readLine()!
    let result = Int(input)!
    return result
}
