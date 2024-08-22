//
//  main.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/22/24.
//

import Foundation

solve()

func solve() {
    
    var caseNum: Int = 1
    
    while true {
        let caveRow = readInt()
        
        if caveRow > 0 {
            solveCase(caveRow: caveRow, caseNum: caseNum)
            caseNum += 1
        } else {
            return 
        }
    }
}

func solveCase(caveRow: Int, caseNum: Int) {
    let cave = readCave(rowCount: caveRow)
    let minLost = searchMinLost(cave: cave)
    
    print("Problem \(caseNum): \(minLost)")
}

func searchMinLost(cave: [[Int]]) -> Int {
    let rowCount = cave.count
    var memoijationCave: [[Int]] = Array(repeating: Array(repeating: .max, count: rowCount), count: rowCount)
    let dists: [Coordinate] = Coordinate.dists
    
    var queue = Queue<Coordinate>()
    let firstCoor = Coordinate(row: 0, col: 0)
    memoijationCave[0][0] = cave[0][0]
    queue.enqueue(firstCoor)
    
    while !queue.isEmpty {
        let currentCoor = queue.dequeue()!
        let currentCost = memoijationCave[currentCoor.row][currentCoor.col]
        
        for dist in dists {
            let newRow = currentCoor.row + dist.row
            let newCol = currentCoor.col + dist.col
            let newCoor = Coordinate(row: newRow, col: newCol)
            
            if isEnqueueable(cave: cave, memCave: memoijationCave, coor: newCoor, additionalCost: currentCost) {
                queue.enqueue(newCoor)
                let newMemCost = currentCost + cave[newRow][newCol]
                memoijationCave[newRow][newCol] = newMemCost
            }
        }
    }
    
    return memoijationCave[rowCount - 1][rowCount - 1]
}

func isEnqueueable(cave: [[Int]], memCave: [[Int]], coor: Coordinate, additionalCost: Int) -> Bool {
    guard isValidCoor(coor: coor, max: memCave.count) else { return false }
    
    return additionalCost + cave[coor.row][coor.col] < memCave[coor.row][coor.col]
}

func isValidCoor(coor: Coordinate, max: Int) -> Bool {
    return coor.row >= 0 && coor.row < max
    && coor.col >= 0 && coor.col < max
}

func readCave(rowCount: Int) -> [[Int]] {
    var result: [[Int]] = []
    
    (0..<rowCount).forEach { _ in
        let thiefRupeeInRow = readThiefRupeeInRow()
        result.append(thiefRupeeInRow)
    }
    
    return result
}

func readThiefRupeeInRow() -> [Int] {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    let thiefRupeeInRow = splitedInput.map { Int($0)! }
    return thiefRupeeInRow
}



func readInt() -> Int {
    let input = readLine()!
    return Int(input)!
}

struct Coordinate {
    let row: Int
    let col: Int
    
    static let dists: [Coordinate] = [
        right, left, up, down
    ]
    
    private static let right = Coordinate(row: 0, col: 1)
    private static let left = Coordinate(row: 0, col: -1)
    private static let up = Coordinate(row: 1, col: 0)
    private static let down = Coordinate(row: -1, col: 0)
}

struct Queue<Element> {
    private var inStack = [Element]()
    private var outStack = [Element]()
    
    var isEmpty: Bool {
        inStack.isEmpty && outStack.isEmpty
    }
    
    mutating func enqueue(_ newElement: Element) {
        inStack.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if outStack.isEmpty {
            outStack = inStack.reversed()
            inStack.removeAll()
        }
        
        return outStack.popLast()
    }
}
