//
//  Solver17142.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver17142 {
    
    /// 설계
    ///
    /// 조건
    /// [v] 활성화된 바이러스는 상하좌우로 퍼진다(BFS)
    /// [v] M개를 놓을 수 있다
    /// [v] 초기에 0으로 입력된 바이러스를 모두 없애면 된다.
    /// [v] 바이러스가 전체 영역에 퍼질 수 없는 경우 -1

    /// M개 놓기를 Brute force로 풀이하면?
    /// O(N^3)
    /// 여기에 BFS는 대충 N
    /// 전체 시간복잡도는 O(N^4)

    let (labSize, virusCount): (Int, Int)
    let initialMap: [[Int]]

    var cleanCoordinateCount = 0
    var virusCoordinates: [Coordinate] = []
    
    init() {
        let (l, v) = readConditions()
        self.labSize = l
        self.virusCount = v
        
        self.initialMap = readInitialMap(labSize: labSize)
    }
    
    
    mutating func solve() {
        setVirusInformations()
        let result = findMinSpreadTime()

        print(result)
    }

    func findMinSpreadTime() -> Int {
        var result = -1
        
        guard cleanCoordinateCount != 0 else {
            return 0
        }
        
        let combinations = virusCoordinates.combinations(of: virusCount)
        
        for combination in combinations {
            let minSpreadTime = spreadVirus(activeVirusCoordinates: combination)
            
            if minSpreadTime != -1 {
                if result == -1 {
                    result = minSpreadTime
                } else {
                    result = min(minSpreadTime, result)
                }
            }
        }
        
        return result
    }

    func spreadVirus(activeVirusCoordinates: [Coordinate]) -> Int {
        var remainCleanCoordinateCount = cleanCoordinateCount
        
        var lastTime = 0
        var spreadMap = initialMap
        
        var spreadQueue = Queue<Coordinate>()
        
        for activeVirusCoordinate in activeVirusCoordinates {
            let r = activeVirusCoordinate.row
            let c = activeVirusCoordinate.col
            spreadQueue.enqueue(activeVirusCoordinate)
            
            /// 활성 바이러스가 있는 곳은 -3
            spreadMap[r][c] = -3
        }
        
        while !(spreadQueue.isEmpty || remainCleanCoordinateCount == 0) {
            let currentCoordinate = spreadQueue.dequeue()!
            let nextCoordinates = currentCoordinate.getNextCoordinates(rowSize: labSize, colSize: labSize)
        
            for nextCoordinate in nextCoordinates {
                let nextR = nextCoordinate.row
                let nextC = nextCoordinate.col
                
                if spreadMap[nextR][nextC] == 0 {
                    spreadMap[nextR][nextC] = nextCoordinate.time
                    remainCleanCoordinateCount -= 1
                    spreadQueue.enqueue(nextCoordinate)
                    lastTime = nextCoordinate.time
                } else if spreadMap[nextR][nextC] == -2 {
                    spreadMap[nextR][nextC] = nextCoordinate.time
                    spreadQueue.enqueue(nextCoordinate)
                    lastTime = nextCoordinate.time
                }
            }
        }
        
        return remainCleanCoordinateCount == 0 ? lastTime : -1
    }

    mutating func setVirusInformations() {
        (0..<labSize).forEach { i in
            (0..<labSize).forEach { j in
                if initialMap[i][j] == -2 {
                    let coordinate = Coordinate(row: i, col: j, time: 0)
                    virusCoordinates.append(coordinate)
                } else if initialMap[i][j] == 0 {
                    cleanCoordinateCount += 1
                }
            }
        }
    }

    struct Coordinate {
        let row: Int
        let col: Int
        let time: Int
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있는 위치를 반환합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func getNextCoordinates(rowSize: Int, colSize: Int) -> [Coordinate] {
            var nextCoordinates: [Coordinate] = []
                
            let left = Coordinate(row: row, col: col - 1, time: time + 1)
            let right = Coordinate(row: row, col: col + 1, time: time + 1)
            let up = Coordinate(row: row - 1, col: col, time: time + 1)
            let down = Coordinate(row: row + 1, col: col, time: time + 1)
            
            let candidates = [left, right, up, down]
            
            for candidate in candidates {
                if candidate.isValidCoordinate(rowSize: rowSize, colSize: colSize) {
                    nextCoordinates.append(candidate)
                }
            }
            
            return nextCoordinates
        }
        
        private func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
            self.row >= 0 && self.row < rowSize && self.col >= 0 && self.col < colSize
        }
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

}

private func readInitialMap(labSize: Int) -> [[Int]] {
    var labMap: [[Int]] = []
    
    (0..<labSize).forEach { _ in
        let line = readLine()!
        let splitedLine = line.split(separator: " ")
        let rowMapInfo = splitedLine.map { Int($0)! * -1 }
        labMap.append(rowMapInfo)
    }
    
    return labMap
}

private func readConditions() -> (Int, Int) {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    let n = Int(splitedInput[0])!
    let m = Int(splitedInput[1])!
    
    return (n, m)
}

private extension Array {
    /// 배열의 원소들로부터 원하는 개수의 조합을 생성합니다.
    /// - Parameter k: 선택할 원소의 개수
    /// - Returns: 생성된 조합들의 배열
    func combinations(of k: Int) -> [[Element]] {
        guard k > 0 else { return [[]] }
        guard let first = self.first else { return [] }
        
        let subarray = Array(self.dropFirst())
        let withFirst = subarray.combinations(of: k - 1).map { [first] + $0 }
        let withoutFirst = subarray.combinations(of: k)
        
        return withFirst + withoutFirst
    }
}

