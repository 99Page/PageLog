//
//  Solver4991.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver4991 {
    var room: [[Character]] = []
    var nodes: [[Int]] = []
    var rowSize = 0
    var colSize = 0
    
    let cleanSpace: Character = "."
    let dirtySpace: Character = "*"
    let filledSpace: Character = "x"
    let robotStartPosition: Character = "o"
    
    var output: [Int] = []
    
    var isCleaningTerminal: Bool {
        rowSize == 0 && colSize == 0
    }
    
    mutating func solve() {
        cleaningRooms()
        printOutput()
    }
    
    private func printOutput() {
        print(output.map({ String($0)}).joined(separator: "\n"))
    }
    
    private mutating func cleaningRooms() {
        while true {
            readRoomMeta()
            
            if isCleaningTerminal {
                return
            }
            
            readMap()
            labelNode()
            cleaningRoom()
        }
    }
    
    private mutating func labelNode() {
        var dirtyRoomLabel = 1
        let robotLabel = 0
        
        nodes = room.map { $0.map { _ in -1 } }
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if room[row][col] == dirtySpace {
                    nodes[row][col] = dirtyRoomLabel
                    dirtyRoomLabel += 1
                } else if room[row][col] == robotStartPosition {
                    nodes[row][col] = robotLabel
                }
            }
        }
    }
    
    private mutating func cleaningRoom() {
        let edges = makeEdges()
        let dirtyRoomCount = countDirtyRoom()
        
        var costs: [[Int]] = Array(repeating: Array(repeating: 0, count: dirtyRoomCount + 1), count: dirtyRoomCount + 1)
        
        for edge in edges {
            costs[edge.source][edge.destination] = edge.weight
            costs[edge.destination][edge.source] = edge.weight
        }
        
        var travelingSalesman = TravelingSalesman(cityCount: dirtyRoomCount + 1, travelCost: costs)
        var result = travelingSalesman.findMinimumTourCost(returnToStart: false)
        result = result == travelingSalesman.INF ? -1 : result
        
        output.append(result)
    }
    
    private func makeEdges() -> [Edge] {
        var result: [Edge] = []
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if room[row][col] == robotStartPosition || room[row][col] == dirtySpace {
                    let start = Coordinate(row: row, col: col, distance: 0)
                    let edges = makeEdges(from: start)
                    result.append(contentsOf: edges)
                }
            }
        }
        return result
    }
    
    private func makeEdges(from start: Coordinate) -> [Edge] {
        let source = nodes[start.row][start.col]
        guard source != 0 else { return [] }
        
        var visitMap = room.map { $0.map { _ in false } }
        var result: [Edge] = []
        
        var queue = Queue<Coordinate>()
        queue.enqueue(start)
        visitMap[start.row][start.col] = true
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            if room[current.row][current.col] == dirtySpace || room[current.row][current.col] == robotStartPosition {
                let destination = nodes[current.row][current.col]
                let edge = Edge(source: source, destination: destination, weight: current.distance)
                result.append(edge)
            }
            
            for neighbor in current.neighbors(rowSize: rowSize, colSize: colSize) {
                if !visitMap[neighbor.row][neighbor.col] && room[neighbor.row][neighbor.col] != filledSpace {
                    visitMap[neighbor.row][neighbor.col] = true
                    queue.enqueue(neighbor)
                }
            }
        }
        return result
    }
    
    private func robotPosition() -> Coordinate {
        
        var robotPosition = Coordinate(row: 0, col: 0, distance: 0)
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if room[row][col] == robotStartPosition {
                    robotPosition = Coordinate(row: row, col: col, distance: 0)
                }
            }
        }
        
        return robotPosition
    }

    private func countDirtyRoom() -> Int{
        var result = 0
        
        for rowMap in room {
            for cell in rowMap {
                if cell == dirtySpace {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    private mutating func readMap() {
        room = []
        
        (0..<rowSize).forEach { _ in
            let rowMap: [Character] = Array(readLine()!)
            room.append(rowMap)
        }
    }
    
    private mutating func readRoomMeta() {
        let input: [Int] = readArray()
        rowSize = input[1]
        colSize = input[0]
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
    /// 간선 정보를 담은 구조체
    struct Edge: Comparable {
        static func < (lhs: Edge, rhs: Edge) -> Bool {
            lhs.weight < rhs.weight
        }
        
        let source: Int
        let destination: Int
        let weight: Int
    }
    
    /// 외판원 문제(Traveling Salesman Problem, TSP)를 Bitmask + DP 방식으로 해결하는 구조체입니다.
    struct TravelingSalesman {
        
        /// 도시의 개수
        let cityCount: Int
        
        /// 각 도시 간 이동 비용 (travelCost[i][j]는 i에서 j로 가는 비용)
        let travelCost: [[Int]]
        
        /// 메모이제이션 배열
        /// memoization[currentCity][visitedMask]는
        /// 현재 currentCity에 위치하며 visitedMask로 나타낸 도시들을 방문한 상태일 때
        /// 남은 도시를 모두 방문하고 시작점으로 돌아오는 최소 비용을 저장합니다.
        var memoization: [[Int]]
        
        /// 연결이 없는 경우 사용할 충분히 큰 숫자
        let INF = Int.max / 2

        /// 생성자: 도시 수와 이동 비용 행렬을 초기화합니다.
        init(cityCount: Int, travelCost: [[Int]]) {
            self.cityCount = cityCount
            self.travelCost = travelCost
            self.memoization = Array(
                repeating: Array(repeating: -1, count: 1 << cityCount),
                count: cityCount
            )
        }

        /// 외판원 문제의 최소 비용을 계산합니다.
        /// 시작 도시는 0번 도시로 고정되어 있습니다.
        /// - Parameter returnToStart: true면 시작점으로 돌아오는 경로, false면 그냥 끝나는 경로
        mutating func findMinimumTourCost(returnToStart: Bool = true) -> Int {
            return computeMinCost(currentCity: 0, visitedMask: 1 << 0, returnToStart: returnToStart)
        }

        /// 현재 도시와 방문한 도시 집합을 기준으로 최소 경로 비용을 재귀적으로 계산합니다.
        ///
        /// - Parameters:
        ///   - currentCity: 현재 위치한 도시
        ///   - visitedMask: 방문한 도시를 나타내는 비트마스크
        ///   - returnToStart: 시작점으로 돌아오는 경로인지 여부
        /// - Returns: 해당 상태에서의 최소 경로 비용
        private mutating func computeMinCost(currentCity: Int, visitedMask: Int, returnToStart: Bool) -> Int {
            // 모든 도시를 방문한 경우 → 시작 도시로 복귀 비용 반환 또는 종료
            if visitedMask == (1 << cityCount) - 1 {
                if returnToStart {
                    return travelCost[currentCity][0] != 0 ? travelCost[currentCity][0] : INF
                } else {
                    return 0
                }
            }

            // 이미 계산된 경우 메모값 사용
            if memoization[currentCity][visitedMask] != -1 {
                return memoization[currentCity][visitedMask]
            }

            var minCost = INF

            // 다음 도시 후보 순회
            for nextCity in 0..<cityCount {
                let alreadyVisited = visitedMask & (1 << nextCity) != 0
                let hasRoute = travelCost[currentCity][nextCity] != 0

                if alreadyVisited || !hasRoute { continue }

                // 다음 도시 방문 상태 업데이트
                let updatedMask = visitedMask | (1 << nextCity)

                // 다음 도시로 이동한 후의 비용 + 현재 도시에서 다음 도시로 가는 비용
                let candidateCost = computeMinCost(currentCity: nextCity, visitedMask: updatedMask, returnToStart: returnToStart) + travelCost[currentCity][nextCity]

                // 최소 비용 갱신
                minCost = min(minCost, candidateCost)
            }

            // 메모이제이션 저장 후 반환
            memoization[currentCity][visitedMask] = minCost
            return minCost
        }
    }

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

