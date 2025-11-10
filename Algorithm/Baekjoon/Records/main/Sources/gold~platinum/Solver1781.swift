//
//  Solver1781.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1781 {
    let homeworkCount = Int(readLine()!)!
    var homeworks: [Homework] = []
    var nearestAvailableDeadline: [Int] = []
    var noodles: [Int] = []
    
    mutating func solve() {
        readInputs()
        findMaxNoodleCount()
        
        let sum = noodles.reduce(into: 0) { partialResult, value in
            partialResult += value
        }
        
        print(sum)
    }
    
    /// 받을 수 있는 최대 컵라면 개수를 구합니다.
    /// - Returns: 최대 컵라면 개수
    mutating func findMaxNoodleCount() {
        var homeworkPQ = Heap<Homework>.maxHeap()
        
        for homework in homeworks {
            homeworkPQ.insert(homework)
        }
        
        while !homeworkPQ.isEmpty {
            let homework = homeworkPQ.pop()!
            
            let _ = fillNoodle(to: homework.deadline, noddleCount: homework.noddleCount)
        }
    }
    
    mutating func fillNoodle(to deadline: Int, noddleCount: Int) -> Int {
        guard deadline != 0 else { return 0 }
        
        if noodles[deadline] == 0 {
            noodles[deadline] = noddleCount
            return nearestAvailableDeadline[deadline]
        } else {
            let emptyDeadline = nearestAvailableDeadline[deadline]
            let find = fillNoodle(to: emptyDeadline, noddleCount: noddleCount)
            nearestAvailableDeadline[deadline] = find
            return find
        }
    }
    
    
    /// 숙제의 정보를 입력받습니다.
    mutating func readInputs() {
        var maxDeadLine = 0
        
        (0..<homeworkCount).forEach { _ in
            let input: [Int] = Reader.readArray()
            let homework = Homework(deadline: input[0], noddleCount: input[1])
            homeworks.append(homework)
            maxDeadLine = max(maxDeadLine, input[0])
        }
        
        nearestAvailableDeadline.append(0)
        
        for index in 1...maxDeadLine {
            nearestAvailableDeadline.append(index - 1)
        }
    }
    
    struct Heap<Element: Comparable> {
        private let comparator: (Element, Element) -> Bool
        private(set) var storage: [Element] = []
        
        init(comparator: @escaping (Element, Element) -> Bool) {
            self.comparator = comparator
        }
        
        var isEmpty: Bool {
            storage.isEmpty
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
    
    
    
    struct Reader {
        static func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
            var result: [[T]] = []
            
            (0..<k).forEach { _ in
                let array: [T] = readArray()
                result.append(array)
            }
            
            return result
        }
        
        static func readArray<T: LosslessStringConvertible>() -> [T] {
            let line = readLine()!
            let splitedLine = line.split(separator: " ")
            let array = splitedLine.map { T(String($0))! }
            return array
        }
        
    }
    
    struct Homework: Comparable {
        static func < (lhs: Homework, rhs: Homework) -> Bool {
            if lhs.noddleCount != rhs.noddleCount {
                return lhs.noddleCount < rhs.noddleCount
            } else {
                return lhs.deadline < rhs.deadline
            }
        }
        
        let deadline: Int
        let noddleCount: Int
    }
}
