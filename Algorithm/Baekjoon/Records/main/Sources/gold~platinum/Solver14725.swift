//
//  Solver14725.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver14725 {
    let feedCount: Int
    
    var roots: [Room] = []
    
    init() {
        self.feedCount = Int(readLine()!)!
    }
    
    mutating func solve() {
        readRoom()
        printRooms()
    }
    
    mutating private func printRooms() {
        roots.sort  { $0.current < $1.current }
        
        for root in roots {
            printRoom(room: root)
        }
    }
    
    private func printRoom(room: Room, indent: Int = 0) {
        var prefix = ""
        
        for _ in 0..<indent {
            prefix += "--"
        }
        
        
        print("\(prefix)\(room.current)")
        
        room.childs.sort { $0.current < $1.current }
        
        for child in room.childs {
            printRoom(room: child, indent: indent + 1)
        }
    }
    
    private mutating func readRoom() {
        (0..<feedCount).forEach { _ in
            let pathInput: [String] = readArray()
            let rooms: [String] = Array(pathInput[1..<pathInput.count])
            
            var rootCopy = roots // root를 로컬 변수에 복사하여 접근
            buildTree(target: &rootCopy, input: rooms)
            roots = rootCopy // 수정된 root를 다시 할당
        }
    }

    private mutating func buildTree(target: inout [Room], input: [String]) {
        guard !input.isEmpty else { return }
        
        let first = input[0]
        let nextTarget = target.first(where: { $0.current == first })
        let nextInput: [String] = Array(input[1..<input.count])
        
        if nextTarget != nil {
            buildTree(target: &nextTarget!.childs, input: nextInput)
        } else {
            let newRoom = Room(current: first)
            target.append(newRoom)
            buildTree(target: &newRoom.childs, input: nextInput)
        }
    }
    
    
    class Room {
        let current: String
        var childs: [Room]
        
        init(current: String) {
            self.current = current
            self.childs = []
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

