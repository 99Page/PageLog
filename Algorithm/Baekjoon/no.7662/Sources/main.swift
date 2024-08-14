//
//  File.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/14/24.
//

import Foundation

print("??")

var pq = PriorityQueue<Int>()

pq.push(40)
pq.push(60)
pq.push(10)
pq.push(50)

print("!!")
print(pq.pop())
print(pq.pop())
print(pq.pop())
print(pq.pop())
print(pq.pop())

struct PriorityQueue<Element: Comparable> {
    var elements: [Element] = []
    let compare: (Element, Element) -> Bool
    
    init(compare: @escaping (Element, Element) -> Bool = { $0 < $1 }) {
        self.compare = compare
    }
    
    mutating func push(_ element: Element) {
        elements.append(element)
        
        var newElementIndex = max(elements.count - 1, 0)
        
        while hasHighPriorityThanParent(index: newElementIndex) {
            newElementIndex = swapElement(index: newElementIndex)
        }
        
        print(elements)
    }
    
    mutating func pop() -> Element? {
        guard elements.count > 0 else { return nil }
        
        let result = elements[0]
        
        moveLastElementToTop()
        
        var movedElementIndex = 0
        
        while hasLowPrioirtyThanChilds(index: movedElementIndex) {
            movedElementIndex = swapToHigherPriorityChild(movedElementIndex: movedElementIndex)
        }
        
        return result
    }
    
    private mutating func swapToHigherPriorityChild(movedElementIndex: Int) -> Int {
        let leftChildIndex = movedElementIndex * 2 + 1
        let rightChildIndex = movedElementIndex * 2 + 2
        
        let leftChildElement = getElementSafely(index: leftChildIndex)
        let rightChildElement = getElementSafely(index: rightChildIndex)
        
        if let rightChildElement, let leftChildElement {
            let hasLeftChildHigherPriority = compare(leftChildElement, rightChildElement)
            let targetIndex = hasLeftChildHigherPriority ? leftChildIndex : rightChildIndex
            swapElement(index1: movedElementIndex, index2: targetIndex)
            return targetIndex
        } else if let leftChildElement {
            swapElement(index1: movedElementIndex, index2: leftChildIndex)
        }
        
        return movedElementIndex
    }
    
    private func hasLowPrioirtyThanChilds(index: Int) -> Bool {
        let leftChildIndex = index * 2 + 1
        let rightChildIndex = index * 2 + 2
        
        let leftChildElement = getElementSafely(index: leftChildIndex)
        let rightChildElement = getElementSafely(index: rightChildIndex)
        
        if let leftChildElement {
            return compare(leftChildElement, elements[index])
        } else if let rightChildElement {
            return compare(rightChildElement, elements[index])
        } else {
            return false
        }
        
    }
    
    private func getElementSafely(index: Int) -> Element? {
        guard elements.count > index else { return nil}
        return elements[index]
    }
    
    private mutating func moveLastElementToTop() {
        guard let last = elements.last,
        elements.count > 1 else {
            elements.removeLast()
            return
        }
        
        elements.removeLast()
        elements[0] = last
    }
    
    private mutating func swapElement(index1: Int, index2: Int) {
        let temporaryElement = elements[index1]
        
        elements[index1] = elements[index2]
        elements[index2] = temporaryElement

    }
    
    
    private mutating func swapElement(index: Int) -> Int {
        let parentIndex = index / 2
        
        let newElement = elements[index]
        let parentElement = elements[parentIndex]
        
        elements[parentIndex] = newElement
        elements[index] = parentElement
        
        return parentIndex
    }
    
    private func hasHighPriorityThanParent(index: Int) -> Bool {
        let parentIndex = index / 2
        let newElement = elements[index]
        let parentElement = elements[parentIndex]
        
        return compare(newElement, parentElement)
    }
}
