//
//  Solver2234.swift
//  baekjoon-solve
//
//  Created by 노우영 on 7/30/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver2234 {
    let rowSize: Int
    let colSize: Int
    
    let wallInput: [[Int]]
    
    var wallMap: [[[Wall]]] = []
    var markMap: [[Int]]
    var roomCount = 0
    var maxRoomSize = 0
    var mark = 1
    
    // key: 맵의 mark
    // value: key 값의 옆에 있는 방들의 mark
    var neighborRoom: [Int: Set<Int>] = [:]
    var roomSizes: [Int] = [0]
    
    init() {
        let sizeInput: [Int] = readArray()
        self.rowSize = sizeInput[1]
        self.colSize = sizeInput[0]
        
        var wallInput: [[Int]] = []
        
        (0..<rowSize).forEach { _ in
            let wallRow: [Int] = readArray()
            wallInput.append(wallRow)
        }
        
        self.wallInput = wallInput
        markMap = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
    }
    
    mutating func solve() {
        makeMap()
        visitRoom()
        let maxExpandedRoomSize = calculateMaxExpandedRoomSize()
        
        print(roomCount)
        print(maxRoomSize)
        print(maxExpandedRoomSize)
    }
    
    mutating func calculateMaxExpandedRoomSize() -> Int {
        var maxExpandedRoomSize = 0
        
        for roomMark in 1...mark-1 {
            let currentRoomSize = roomSizes[roomMark]
            let neighbor = neighborRoom[roomMark] ?? []
            
            for neighborMark in neighbor  {
                let neighborRoomSize = roomSizes[neighborMark]
                let sumOfRoomSize = currentRoomSize + neighborRoomSize
                maxExpandedRoomSize = max(maxExpandedRoomSize, sumOfRoomSize)
            }
        }
        
        return maxExpandedRoomSize
    }
    
    mutating func visitRoom() {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if markMap[row][col] == 0{
                    let coordinate = Coordinate(row: row, col: col, distance: 0)
                    let roomSize = checkRoomSize(from: coordinate)
                    maxRoomSize = max(maxRoomSize, roomSize)
                    roomCount += 1
                    mark += 1
                    roomSizes.append(roomSize)
                }
            }
        }
    }
    
    mutating func checkRoomSize(from coordinate: Coordinate) -> Int {
        var queue = Queue<Coordinate>()
        let path: Set<Wall> = [.e, .n, .s, .w]
        var roomSize = 0
        
        queue.enqueue(coordinate)
        markMap[coordinate.row][coordinate.col] = mark
        roomSize += 1
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            let walls = wallMap[current.row][current.col]
            let nextPath = path.subtracting(walls)
            
            for path in nextPath {
                let nextRow = current.row + path.additionalRow
                let nextCol = current.col + path.additionalCol
                let nextCoor = Coordinate(row: nextRow, col: nextCol, distance: 0)
                
                if nextCoor.isValidCoordinate(rowSize: rowSize, colSize: colSize) && markMap[nextRow][nextCol] == 0 {
                    queue.enqueue(nextCoor)
                    markMap[nextRow][nextCol] = mark
                    roomSize += 1
                }
            }
            
            for path in path {
                let nextRow = current.row + path.additionalRow
                let nextCol = current.col + path.additionalCol
                let nextCoor = Coordinate(row: nextRow, col: nextCol, distance: 0)
                
                if nextCoor.isValidCoordinate(rowSize: rowSize, colSize: colSize) {
                    let neighborMark = markMap[nextRow][nextCol]
                    if neighborMark != mark && neighborMark != 0 {
                        neighborRoom[mark, default: []].insert(neighborMark)
                    }
                }
            }
        }
        
        return roomSize
    }
    
    mutating func makeMap() {
        wallMap = Array(repeating: Array(repeating: [], count: colSize), count: rowSize)
        
        for (row, wallRow) in wallInput.enumerated() {
            for (col, wallValue) in wallRow.enumerated() {
                var wallValue = wallValue
                
                for wall in Wall.allCases {
                    let remain = wallValue % 2
                    
                    if remain == 1 {
                        wallMap[row][col].append(wall)
                    }
                    
                    wallValue /= 2
                }
            }
        }
    }
    
    struct Coordinate {
        let row: Int
        let col: Int
        let distance: Int
        let arrayIndexBase: ArrayIndexBase
        
        init(row: Int, col: Int, distance: Int, arrayIndexBase: ArrayIndexBase = .zero) {
            self.row = row
            self.col = col
            self.distance = distance
            self.arrayIndexBase = arrayIndexBase
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
                    Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase)
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
                    Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase)
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

    
    enum Wall: CaseIterable {
        case w
        case n
        case e
        case s
        
        var additionalRow: Int {
            switch self {
            case .w:
                return 0
            case .n:
                return -1
            case .e:
                return 0
            case .s:
                return 1
            }
        }
        
        var additionalCol: Int {
            switch self {
            case .w:
                return -1
            case .n:
                return 0
            case .e:
                return 1
            case .s:
                return 0
            }
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

