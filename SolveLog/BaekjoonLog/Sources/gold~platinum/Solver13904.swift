//
//  Solver13904.swift
//  baekjoon-solve
//
//  Created by 노우영 on 7/5/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

//3
//2 20
//1 10
//1 5

//3
//1 5
//2 30
//2 40


// 문제에서 배열이 주어졌고,
// 배열은 항상 정렬이 가능한지 파악해야합니다.
// 마감일, 점수 모두 정렬하기 적합한 값들입니다.
// 정렬이 가능하면 이분탐색이 가능한지도 확인합니다.
// 문제 특성상, 이분탐색을 하기엔 적합하지 않습니다.

// 이 문제를 그리디로 접근하기로 했습니다.
// 정렬과 그리디를 같이 사용할 때는 정렬의 기준의
// 그리디의 기준이 됩니다.
// 마감일/점수 중 무엇의 우선순위가 높은지 파악해야하는데
// 이런 문제의 경우는 경험적으로 마감일의 우선순위가 높습니다.
// 마감일 기준 오름차순으로 먼저 정렬을 하고 카운터 케이스를 생각해봅니다.
// 3
// 1 5
// 2 30
// 2 40
// 카운터 케이스가 발생합니다.
// 하지만 값이 가장 작은거부터 빼주면 쉽게 처리 가능합니다.
// 따라서 minHeap을 같이 사용합니다.
struct Solver13904 {
    let assignmentCount: Int
    let assignments: [Assignment]
    var selectedAssignments = Heap<Assignment>(comparator: Assignment.scoreComparator)
    
    init() {
        self.assignmentCount = Int(readLine()!)!
        
        var assignments: [Assignment] = []
        
        (0..<assignmentCount).forEach { _ in
            let assignmentInput: [Int] = readArray()
            let deadLine = assignmentInput[0]
            let score = assignmentInput[1]
            let assignment = Assignment(deadLine: deadLine, score: score)
            assignments.append(assignment)
        }
        
        self.assignments = assignments
    }
    
    mutating func solve() {
        selectAssignments()
        let answer = calculateMaxScore()
        print(answer)
    }
    
    mutating func calculateMaxScore() -> Int {
        var result = 0
        
        for assignment in selectedAssignments.storage {
            result += assignment.score
        }
        
        return result
    }
    
    mutating func selectAssignments() {
        let sortedAssignments = assignments.sorted()
        
        for assignment in sortedAssignments {
            if selectedAssignments.storage.count < assignment.deadLine {
                selectedAssignments.insert(assignment)
            } else {
                replaceIfHigherScore(assignment)
            }
        }
    }
    
    mutating func replaceIfHigherScore(_ assignment: Assignment) {
        let lowestScoreAssignment = selectedAssignments.peek()!
        
        if assignment.score > lowestScoreAssignment.score {
            let _ = selectedAssignments.pop()
            selectedAssignments.insert(assignment)
        }
    }
    
    struct Assignment: Comparable {
        static func < (lhs: Solver13904.Assignment, rhs: Solver13904.Assignment) -> Bool {
            if lhs.deadLine != rhs.deadLine {
                return lhs.deadLine < rhs.deadLine
            } else {
                return lhs.score > rhs.score
            }
        }
        
        let deadLine: Int
        let score: Int
        
        static var scoreComparator: (Assignment, Assignment) -> Bool {
            { $0.score < $1.score }
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


