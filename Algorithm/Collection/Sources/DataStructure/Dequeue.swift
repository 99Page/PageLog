//
//  Dequeue.swift
//  PageCollection
//
//  Created by 노우영 on 9/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Dequeue<Element> {
    private var frontStack = [Element]()
    private var backStack = [Element]()
    
    /// 덱이 비어있는지 여부를 반환
    var isEmpty: Bool {
        frontStack.isEmpty && backStack.isEmpty
    }
    
    /// 덱의 크기를 반환
    var count: Int {
        return frontStack.count + backStack.count
    }
    
    /// 덱의 앞에 요소를 추가 (O(1))
    /// - Parameter element: 추가할 요소
    mutating func enqueueFront(_ element: Element) {
        frontStack.append(element)
    }
    
    /// 덱의 뒤에 요소를 추가 (O(1))
    /// - Parameter element: 추가할 요소
    mutating func enqueueBack(_ element: Element) {
        backStack.append(element)
    }
    
    /// 덱의 앞에서 요소를 제거하고 반환 (필요할 때 스택을 옮겨서 O(n), 평소에는 O(1))
    /// - Returns: 제거된 요소
    mutating func dequeueFront() -> Element? {
        if frontStack.isEmpty {
            frontStack = backStack.reversed()
            backStack.removeAll()
        }
        return frontStack.popLast()
    }
    
    /// 덱의 뒤에서 요소를 제거하고 반환 (필요할 때 스택을 옮겨서 O(n), 평소에는 O(1))
    /// - Returns: 제거된 요소
    mutating func dequeueBack() -> Element? {
        if backStack.isEmpty {
            backStack = frontStack.reversed()
            frontStack.removeAll()
        }
        return backStack.popLast()
    }
    
    /// 덱의 앞에 있는 요소를 반환하지만 제거하지 않음
    /// - Returns: 첫 번째 요소
    func peekFront() -> Element? {
        return !frontStack.isEmpty ? frontStack.last : backStack.first
    }
    
    /// 덱의 뒤에 있는 요소를 반환하지만 제거하지 않음
    /// - Returns: 마지막 요소
    func peekBack() -> Element? {
        return !backStack.isEmpty ? backStack.last : frontStack.first
    }
}