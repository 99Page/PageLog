//
//  Queue.swift
//  PageCollection
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

public struct Queue<Element> {
    private var inStack = [Element]()
    private var outStack = [Element]()
    
    public init() { }
    
    /// 큐가 비어있는지 여부를 반환합니다.
    public var isEmpty: Bool {
        inStack.isEmpty && outStack.isEmpty
    }

    /// 큐에 있는 요소의 총 개수를 반환합니다.
    public var count: Int {
        inStack.count + outStack.count
    }

    /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
    public var peek: Element? {
        if outStack.isEmpty {
            return inStack.first
        }
        return outStack.last
    }
    
    /// 큐에 요소를 추가합니다.
    /// - Parameter newElement: 큐에 삽입할 요소
    public mutating func enqueue(_ newElement: Element) {
        inStack.append(newElement)
    }
    
    /// 큐에서 요소를 제거하고 반환합니다.
    /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
    public mutating func dequeue() -> Element? {
        if outStack.isEmpty {
            outStack = inStack.reversed()
            inStack.removeAll()
        }
        
        return outStack.popLast()
    }
}
