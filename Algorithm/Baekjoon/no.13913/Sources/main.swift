//
//  main.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/20/24.
//

import Foundation

let maxXCoordinate = 100000
let minXCoordinate = 0

let initialValue = MoveInfo(cost: .max, lastPosition: -1, currentPosition: -1)
var moveInfos: [MoveInfo] = Array(repeating: initialValue, count: maxXCoordinate + 1)
var pq = Heap<MoveInfo>.minHeap()

let (n, k) = readNAndK()

func findMinCostMove() {
    let start = MoveInfo(cost: 0, lastPosition: k, currentPosition: k)
    pq.insert(start)
    
    while !pq.isEmpty {
        let current = pq.pop()!
        
        let newCost = current.cost + 1
        let lastPosition = current.currentPosition
        
        let doubledPosition = current.currentPosition * 2
        
        if isInsertable(index: doubledPosition, newCost: newCost) {
            let moveInfo = MoveInfo(cost: newCost, lastPosition: <#T##Int#>, currentPosition: <#T##Int#>)
            pq.insert(<#T##element: MoveInfo##MoveInfo#>)
        }
    }
}

func isInsertable(index: Int, newCost: Int) -> Bool {
    isValidIndex(index) && newCost < moveInfos[index].cost
}

func isValidIndex(_ index: Int) -> Bool {
    index >= minXCoordinate && index <= maxXCoordinate
}



func readNAndK() -> (Int, Int) {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    
    let n = Int(splitedInput[0])!
    let k = Int(splitedInput[1])!
    
    return (n, k)
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




struct MoveInfo: Comparable {
    static func < (lhs: MoveInfo, rhs: MoveInfo) -> Bool {
        lhs.cost < rhs.cost
    }
    
    let cost: Int
    let lastPosition: Int
    let currentPosition: Int
}
