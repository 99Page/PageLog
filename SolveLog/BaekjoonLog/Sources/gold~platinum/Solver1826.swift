//
//  Solver1826.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

//3
//1 9
//2 5
//3 10
//26 1
//예상 -1.

//3
//1 10
//2 5
//3 10
//26 1
//예상 3

//1
//5 10
//20 20
//예상 0


/// DP + PQ
struct Solver1826 {
    
    /// 주유소의 개수
    var gasStationCount: Int
    
    var currentGas: Int = 0
    
    /// index: 시작점으로부터의 거리.
    /// value: 해당 거리까지 주유한 횟수
    var mem: [Int]
    
    /// 지나쳐온 주유소들에서 넣을 수 있는 연료의 양
    var gasQueue: Heap<Int> = .maxHeap()
    
    /// 마을까지의 거리
    var villageDistance: Int
    
    /// 마을까지의 최대 거리
    var maxVillageDistance = 1_000_000
    
    let gases: [Int]
    
    init() {
        self.gasStationCount = Int(readLine()!)!
        
        var gases: [Int] = Array(repeating: 0, count: maxVillageDistance + 1)
        
        for _ in 0..<gasStationCount {
            let gasStationInput: [Int] = readArray()
            let distance = gasStationInput[0]
            let gas = gasStationInput[1]
            gases[distance] = gas
        }
        
        self.gases = gases
        
        let lastInput: [Int] = readArray()
        
        self.mem = Array(repeating: 0, count: maxVillageDistance + 1)
        self.villageDistance = lastInput[0]
        self.currentGas = lastInput[1]
    }
    
    mutating func solve() {
        
        var isReachedAtVillage = false
        
        for location in 1...villageDistance {
            mem[location] = mem[location - 1]
            currentGas -= 1
            
            if location == villageDistance {
                /// 마을에 도달했으면 더 진행할 필요가 없다.
                isReachedAtVillage = true
                break
            }
            
            if gases[location] != 0 {
                gasQueue.insert(gases[location])
            }
            
            if currentGas == 0 && !gasQueue.isEmpty {
                let maxGas = gasQueue.pop()!
                currentGas += maxGas
                mem[location] += 1
            }
            
            if currentGas == 0 {
                break
            }
        }
        
        let result = isReachedAtVillage ? mem[villageDistance] : -1
        print(result)
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

