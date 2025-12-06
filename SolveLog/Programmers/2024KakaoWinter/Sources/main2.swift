////
////  main.swift
////  2024.kakao.winter
////
////  Created by 노우영 on 9/10/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//var outNode: [Int: Set<Int>] = [:]
//var inNode: [Int: Set<Int>] = [:]
//var isVisited: [Bool] = []
//
//var donutCount = 0
//var barCount = 0
//var figureEightCount = 0
//
////solution([[2, 3], [4, 3], [1, 1], [2, 1]])
////solution([[4, 11], [1, 12], [8, 3], [12, 7], [4, 2], [7, 11], [4, 8], [9, 6], [10, 11], [6, 10], [3, 5], [11, 1], [5, 3], [11, 9], [3, 8]])
//solution([[3, 2], [1, 3], [1, 9], [9, 7], [7, 8], [1,4], [5, 4], [4, 6]])
//
//func solution(_ edges:[[Int]]) -> [Int] {
//    var nodeCount = 0
//    
//    for edge in edges {
//        nodeCount = max(nodeCount, edge[0])
//        nodeCount = max(nodeCount, edge[1])
//        
//        let startNode = edge[0]
//        let endNode = edge[1]
//     
//        add(inNode: startNode, to: endNode)
//        add(outNode: endNode, to: startNode)
//    }
//    
//    isVisited = Array(repeating: false, count: nodeCount + 1)
//    
//    
//    visitNodeHasInDegree()
//    print("inNode: \(inNode)")
//    print("outNode: \(outNode)")
// 
//    
//    return []
//}
//
//func visitNodeHasInDegree() {
//    var zeroInDegreeNodes: [Int] = []
//    
//    for node in 1..<isVisited.count {
//        if let inNode = inNode[node], inNode.count != 0 && !isVisited[node] {
//            print("visit: \(node)")
//            search(node: node, parent: 0)
//        }
//        
//        if inNode[node] == nil {
//            zeroInDegreeNodes.append(node)
//        }
//    }
//    
//    print("zero degree: \(zeroInDegreeNodes)")
//}
//
//func search(node: Int, parent: Int) {
//    var nodeQueue = Queue<(Int, Int)>()
//    
//    nodeQueue.enqueue((node, 0))
//    isVisited[node] = true
//    
//    var lastNodes = (node, 0)
//    var containVisitedNode = false
//    var hasOutdegress = false
//    
//    while !nodeQueue.isEmpty {
//        
//        let currentNodes = nodeQueue.dequeue()!
//        lastNodes = currentNodes
//        
//        let nextNodes = outNode[currentNodes.0] ?? Set<Int>()
//        
//        if nextNodes.count > 1 {
//            hasOutdegress = true
//        }
//        
//        for nextNode in nextNodes {
//            if !isVisited[nextNode] {
//                isVisited[nextNode] = true
//                nodeQueue.enqueue((nextNode, currentNodes.0))
//            } else {
//                containVisitedNode = true
//            }
//        }
//        
//    }
//    
//    if outNode[lastNodes.0] != nil {
//        if inNode[lastNodes.0]?.contains(lastNodes.1) ?? false && inNode[lastNodes.1]?.contains(lastNodes.0) ?? false  {
//            print("node increase donut")
//            donutCount += 1
//        } else if hasOutdegress {
//            print("node increase eight")
//            figureEightCount += 1
//        }
//    } else if !containVisitedNode {
//        print("node increase bar")
//        barCount += 1
//    }
//}
//
//func add(outNode endNode: Int, to startNode: Int) {
//    if !outNode.keys.contains(startNode){
//        outNode[startNode] = Set<Int>()
//    }
//    
//    var outNodeSet = outNode[startNode]
//    outNodeSet?.insert(endNode)
//    
//    outNode[startNode] = outNodeSet
//}
//
//
//
//func add(inNode startNode: Int, to endNode: Int) {
//    if !inNode.keys.contains(endNode) {
//        inNode[endNode] = Set<Int>()
//    }
//    
//    var inNodeSet = inNode[endNode]
//    inNodeSet?.insert(startNode)
//    
//    inNode[endNode] = inNodeSet
//}
//
//
//struct Queue<Element> {
//    private var inStack = [Element]()
//    private var outStack = [Element]()
//    
//    var isEmpty: Bool {
//        inStack.isEmpty && outStack.isEmpty
//    }
//    
//    mutating func enqueue(_ newElement: Element) {
//        inStack.append(newElement)
//    }
//    
//    mutating func dequeue() -> Element? {
//        if outStack.isEmpty {
//            outStack = inStack.reversed()
//            inStack.removeAll()
//        }
//        
//        return outStack.popLast()
//    }
//}
