//
//  Problem20207.swift
//  BaekjoonLog
//
//  Created by 노우영 on 11/12/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 캘린더가 다음 처럼 채워지는 경우
///
/// *****
/// **
///
/// 이 넓이는
///
/// ** ***
/// **
///
/// 이렇게 나눠서 7이 아니라
///
/// *****
/// *****
///
/// 이렇게 만들어져야하니 12가 된다. 
struct Problem20207 {
    
    var numOfEvent = 0
    
    mutating func solve() {
        numOfEvent = Int(readLine()!)!
        var pq = Heap<Event>(comparator: <)
        var endDays = Heap<Int>(comparator: <)
        
        (0..<numOfEvent).forEach { _ in
            let eventInput: [Int] = readArray()
            let event = Event(start: eventInput[0], end: eventInput[1])
            pq.insert(event)
        }
        
        var maxOverlaps = 0
        var currentStartDay = -1
        var currentEndDay = -1
        var blockSize = 0
        
        while !pq.isEmpty {
            let event = pq.pop()!
            
            while !endDays.isEmpty {
                let head = endDays.peek()!
                if head < event.start {
                    let _ = endDays.pop()!
                } else {
                    break
                }
            }

            if event.start > currentEndDay + 1 {
                blockSize += (currentEndDay - currentStartDay + 1) * maxOverlaps
                endDays.insert(event.end)
                currentStartDay = event.start
                currentEndDay = event.end
                maxOverlaps = 1
            } else {
                currentEndDay = max(event.end, currentEndDay)
                endDays.insert(event.end)
                maxOverlaps = max(maxOverlaps, endDays.elements.count)
            }
            
        }
        
        blockSize += (currentEndDay - currentStartDay + 1) * maxOverlaps
        
        print(blockSize)
    }
    
    struct Event: Comparable {
        static func < (lhs: Event, rhs: Event) -> Bool {
            if lhs.start != rhs.start {
                return lhs.start < rhs.start
            } else {
                return lhs.end > rhs.end
            }
        }
        
        let start: Int
        let end: Int
    }
    
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

    
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

