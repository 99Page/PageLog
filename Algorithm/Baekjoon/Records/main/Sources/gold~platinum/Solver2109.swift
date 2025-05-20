//
//  Solver2109.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

//4
//1 10
//2 1
//3 10
//3 10

//4
//10 5
//10 5
//10 5
//1 1

//3
//10 2
//1 1
//10 2


/// 2109번 풀이
///
/// # 문제 접근
/// 브루트 포스 / 백트래킹으로 모든 케이스를 확인할 수는 없습니다. 그리디하게 문제를 접근할 수 있지 확인해야합니다.
///
/// 그리디로 접근할 때는 무엇에 대해서 탐욕적인지 기준을 설정해야합니다. p 혹은 d일 수 있습니다.
///
/// 두가지 모두 카운터 케이스는 존재합니다. 시간에 대한 그리디일 경우, d는 더 늦지만 c는 더 큰 것을 가져오지 못할 수 있습니다. 코스트에 대한 그리디일 경우 d가 넉넉하게 설정되어 있는 것을 먼저 가져왔을 때 문제가 됩니다. ([d=5 c=10], [d=1 c=1])
///
/// 따라서 한가지 기준으로 할 수는 없습니다. 그리고 이런 시간과 비용에 대한 문제는 일반적으로 시간 순 정렬이 우선 순위가 높습니다.
///
/// 1. 시간에 대해 오름차순으로 정렬한다.
/// 2. 순회하면서 비용에 대한 최소 힙에 추가합니다.
///
/// 2.1  강의의 d가 최소 힙에 있는 수보다 크다면 추가합니다.
///
/// 2.2 강의의 d가 최소 힙에 있는 수보다 작다면, 최솟값과 비교 후 더 큰 값을 선택합니다.
///
/// 이렇게 처리하면 모든 예외사항을 처리할 수 있습니다.
struct Solver2109 {
    
    let offerCount: Int
    let lectures: [Lecture]
    var scheduledLecture = Heap<Lecture>.minHeap()
    
    init() {
        self.offerCount = Int(readLine()!)!
        
        var lectures: [Lecture] = []
        
        (0..<offerCount).forEach { _ in
            let input: [Int] = readArray()
            let lecture = Lecture(deadline: input[1], pay: input[0])
            lectures.append(lecture)
        }
        
        self.lectures = lectures
    }
    
    mutating func solve() {
        let result =  calculateMaxEarnings()
        print(result)
    }
    
    private mutating func calculateMaxEarnings() -> Int {
        let sortedLectures = lectures.sorted { $0.deadline < $1.deadline }
        
        for lecture in sortedLectures {
            if scheduledLecture.storage.count < lecture.deadline {
                scheduledLecture.insert(lecture)
            } else {
                replaceIfMoreProfitable(lecture)
            }
        }
        
        return calculateFromScheduledLectures()
    }
    
    private mutating func calculateFromScheduledLectures() -> Int {
        var result = 0
        while !scheduledLecture.storage.isEmpty {
            let current = scheduledLecture.pop()!
            result += current.pay
        }
        return result
    }
    
    private mutating func replaceIfMoreProfitable(_ lecture: Lecture) {
        let minPay = scheduledLecture.peek()!.pay
        if minPay < lecture.pay {
            _ = scheduledLecture.pop()
            scheduledLecture.insert(lecture)
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

    
    struct Lecture: Comparable {
        static func < (lhs: Solver2109.Lecture, rhs: Solver2109.Lecture) -> Bool {
            lhs.pay < rhs.pay
        }
        
        let deadline: Int
        let pay: Int
        
        
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

