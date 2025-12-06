//
//  Solver5427.swift
//  baekjoon-solve
//
//  Created by 노우영 on 7/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver5427 {
    
    let testCount: Int
    
    var rowSize: Int = 0
    var colSize: Int = 0
    var building: [[Character]] = []
    
    var queue = Queue<Coordinate>()
    
    let empty: Character = "."
    let fireMark: Character = "*"
    let sangguen: Character = "@"
    let sangguenVisit: Character = "!"
    
    init() {
        self.testCount = Int(readLine()!)!
    }
    
    mutating func solve() {
        (0..<testCount).forEach { _ in
            readMapMeta()
            readBuilding()
            let turn = runSangguen()
            print(turn != -1 ? turn : "IMPOSSIBLE")
        }
    }
    
    private mutating func runSangguen() -> Int {
        makeFireQueue()
        let sanggen = findSangguen()
        queue.enqueue(sanggen)
        building[sanggen.row][sanggen.col] = sangguenVisit

        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            switch current.type {
            case .sangguen:
                if canExist(current) {
                    return current.distance + 1
                }
                
                moveSanggen(current)
            case .fire:
                burn(current)
            }
        }
        
        return -1
    }
    
    private mutating func burn(_ fire: Coordinate) {
        for neighbor in fire.neighbors(rowSize: rowSize, colSize: colSize) {
            if building[neighbor.row][neighbor.col] == empty {
                building[neighbor.row][neighbor.col] = fireMark
                queue.enqueue(neighbor)
            }
        }
    }
    
    private mutating func canExist(_ coordinate: Coordinate) -> Bool {
        guard coordinate.type == .sangguen else { return false }
        return coordinate.neighbors(rowSize: rowSize, colSize: colSize).count < 4
    }
    
    private mutating func moveSanggen(_ coordinate: Coordinate) {
        for neighbor in coordinate.neighbors(rowSize: rowSize, colSize: colSize) {
            if building[neighbor.row][neighbor.col] == empty{
                building[neighbor.row][neighbor.col] = sangguenVisit
                queue.enqueue(neighbor)
            }
        }
    }
    
    private mutating func makeFireQueue() {
        queue = Queue<Coordinate>()
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if building[row][col] == "*" {
                    let coordinate = Coordinate(row: row, col: col, distance: 0, type: .fire)
                    queue.enqueue(coordinate)
                }
            }
        }
    }
    
    private func findSangguen() -> Coordinate {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if building[row][col] == "@" {
                    return Coordinate(row: row, col: col, distance: 0, type: .sangguen)
                }
            }
        }
        
        fatalError("find sangguen")
    }
    
    private mutating func readBuilding() {
        building = []
        
        (0..<rowSize).forEach { _ in
            building.append([Character](readLine()!))
        }
    }
    
    private mutating func readMapMeta() {
        let mapMeta: [Int] = readArray()
        self.rowSize = mapMeta[1]
        self.colSize = mapMeta[0]
    }
}

struct Queue<Element> {
    private var inStack = [Element]()
    private var outStack = [Element]()
    
    /// 큐가 비어있는지 여부를 반환합니다.
    var isEmpty: Bool {
        inStack.isEmpty && outStack.isEmpty
    }

    /// 큐에 있는 요소의 총 개수를 반환합니다.
    var count: Int {
        inStack.count + outStack.count
    }

    /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
    var peek: Element? {
        if outStack.isEmpty {
            return inStack.first
        }
        return outStack.last
    }
    
    /// 큐에 요소를 추가합니다.
    /// - Parameter newElement: 큐에 삽입할 요소
    mutating func enqueue(_ newElement: Element) {
        inStack.append(newElement)
    }
    
    /// 큐에서 요소를 제거하고 반환합니다.
    /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
    mutating func dequeue() -> Element? {
        if outStack.isEmpty {
            outStack = inStack.reversed()
            inStack.removeAll()
        }
        
        return outStack.popLast()
    }
}


struct Coordinate: Comparable {
    let row: Int
    let col: Int
    let distance: Int
    let arrayIndexBase: ArrayIndexBase
    let type: Object
    
    
    init(row: Int, col: Int, distance: Int, arrayIndexBase: ArrayIndexBase = .zero, type: Object) {
        self.row = row
        self.col = col
        self.distance = distance
        self.arrayIndexBase = arrayIndexBase
        self.type = type
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.distance != rhs.distance {
            return lhs.distance > rhs.distance
        } else {
            return lhs.type == .sangguen && rhs.type == .fire
        }
    }
    
    enum Object {
        case sangguen
        case fire
    }
    
    /// 현재 위치에서 이동할 수 있는 모든 유효한 다음 위치를 반환합니다.
    /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
    /// 이동 가능한 방향은 상, 하, 좌, 우 및 대각선입니다.
    ///
    /// - Parameters:
    ///   - rowSize: 그리드의 행 크기입니다.
    ///   - colSize: 그리드의 열 크기입니다.
    /// - Returns: 모든 방향으로 이동한 유효한 좌표들을 반환합니다.
    func neighborsIncludingDiagonals(rowSize: Int, colSize: Int) -> [Coordinate] {
        let directions = [
            (-1, 0), (1, 0), (0, -1), (0, 1),     // 상, 하, 좌, 우
            (-1, -1), (-1, 1), (1, -1), (1, 1)    // 대각선
        ]
        
        return directions
            .map { (dr, dc) in
                Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase, type: type)
            }
            .filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
    }
    
    /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
    /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
    ///
    /// - Parameters:
    ///   - rowSize: 그리드의 행 크기입니다.
    ///   - colSize: 그리드의 열 크기입니다.
    /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
    func neighbors(rowSize: Int, colSize: Int) -> [Coordinate] {
        let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
        return directions
            .map { (dr, dc) in
                Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase, type: type)
            }
            .filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
        
    }
    
    /// 주어진 그리드 크기에서 현재 좌표가 유효한지 확인합니다.
    /// 이 함수는 정사각형 그리드에 대한 유효성을 검사하는 데 사용됩니다.
    ///
    /// - Parameter gridSize: 정사각형 그리드의 크기입니다. 행과 열의 크기가 동일합니다.
    /// - Returns: 현재 좌표가 유효하다면 `true`, 그렇지 않다면 `false`를 반환합니다.
    func isValidCoordinate(gridSize: Int) -> Bool {
        isValidCoordinate(rowSize: gridSize, colSize: gridSize)
    }
    
    /// 주어진 행 크기와 열 크기를 기준으로 현재 좌표가 유효한지 확인합니다.
    /// 이 함수는 직사각형 그리드에 대한 유효성을 검사하는 데 사용됩니다.
    ///
    /// - Parameters:
    ///   - rowSize: 그리드의 행 크기입니다.
    ///   - colSize: 그리드의 열 크기입니다.
    /// - Returns: 현재 좌표가 유효하다면 `true`, 그렇지 않다면 `false`를 반환합니다.
    func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
        let rowThreshold = rowSize + arrayIndexBase.additionalIndexToSize
        let colThreshold = colSize + arrayIndexBase.additionalIndexToSize
        
        return self.row >= arrayIndexBase.minIndex && self.row < rowThreshold
        && self.col >= arrayIndexBase.minIndex && self.col < colThreshold
    }
    
    enum ArrayIndexBase {
        case zero
        case one
        
        var minIndex: Int {
            switch self {
            case .zero:
                return 0
            case .one:
                return 1
            }
        }
        
        var additionalIndexToSize: Int { self.minIndex }
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

