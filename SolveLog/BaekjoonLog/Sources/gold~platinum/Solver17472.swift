//
//  Solver17472.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/21/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver17472 {
    let rowSize: Int
    let colSize: Int
    
    let inputMap: [[Int]]
    var isMigrated: [[Bool]]
    
    var identifiedMap: [[Int]]
    
    var islandCount = 0
    var bridges: [Bridge] = []
    
    init() {
        let metaInput: [Int] = readArray()
        rowSize = metaInput[0]
        colSize = metaInput[1]
        
        var inputMap: [[Int]] = []
        
        (0..<rowSize).forEach { _ in
            let row: [Int] = readArray()
            inputMap.append(row)
        }
        
        self.inputMap = inputMap
        self.isMigrated = Array(repeating: Array(repeating: false, count: colSize), count: rowSize)
        self.identifiedMap = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
    }
    
    mutating func solve() {
        makeIdentifiedMap()
        makeBridge()
        calculateMinLenght()
    }
    
    private func calculateMinLenght() {
        let sortedBridges = bridges.sorted()
        
        var unionFinder = UnionFindSolver(arrayIndexBase: .one(nodeCount: islandCount))
        var connectCount = 0
        var totalWeight = 0
        
        for bridge in sortedBridges {
            let island1 = bridge.linkedIsland[0]
            let island2 = bridge.linkedIsland[1]
            /// 두 노드가 연결되지 않았다면 연결

            if !unionFinder.isConnected(island1, island2) {
                unionFinder.union(island1, island2)
                connectCount += 1
                totalWeight += bridge.lenght
            }

            /// 모든 노드가 연결되면 종료
            if connectCount == islandCount - 1 {
                print(totalWeight)
                return
            }
        }

        print("-1")
    }
    
    /// UnionFind 구조체는 서로소 집합(Disjoint Set)을 구현한 자료구조로,
    /// 빠르게 집합을 병합하거나(Union) 두 요소가 같은 집합에 속하는지 확인(Find)할 수 있습니다.
    /// 인덱스 기반 처리를 위해 ArrayIndexBase를 지원합니다.
    struct UnionFindSolver {
        private var parent: [Int]
        private var rank: [Int]
        private let arrayIndexBase: ArrayIndexBase
        
        /// 유니온 파인드 초기화
        /// - Parameters:
        ///   - size: 초기 집합의 크기 (노드의 개수)
        ///   - arrayIndexBase: 배열 인덱스 기준 (0부터 또는 1부터 시작)
        init(arrayIndexBase: ArrayIndexBase) {
            self.arrayIndexBase = arrayIndexBase
            let arraySize = arrayIndexBase.arraySize
            self.parent = Array(0..<arraySize) // 각 노드는 자신을 부모로 설정
            self.rank = Array(repeating: 0, count: arraySize) // 모든 노드의 랭크는 0으로 초기화
        }
        
        /// 주어진 노드가 속한 집합의 루트를 찾습니다 (경로 압축 기법 사용).
        /// - Parameter node: 찾고자 하는 노드
        /// - Returns: 해당 노드가 속한 집합의 루트
        mutating func find(_ node: Int) -> Int {
            if parent[node] != node {
                parent[node] = find(parent[node])
            }
            
            return parent[node]
        }
        
        /// 두 노드를 동일한 집합으로 병합합니다 (유니온).
        /// - Parameters:
        ///   - node1: 첫 번째 노드
        ///   - node2: 두 번째 노드
        mutating func union(_ node1: Int, _ node2: Int) {
            let root1 = find(node1)
            let root2 = find(node2)
            
            if root1 == root2 {
                return
            }
            
            // 랭크 기반 병합: 더 높은 랭크를 가진 트리를 루트로 설정
            if rank[root1] > rank[root2] {
                parent[root2] = root1
            } else if rank[root1] < rank[root2] {
                parent[root1] = root2
            } else {
                parent[root2] = root1
                rank[root1] += 1
            }
        }
        
        /// 두 노드가 같은 집합에 속해 있는지 확인합니다.
        /// - Parameters:
        ///   - node1: 첫 번째 노드
        ///   - node2: 두 번째 노드
        /// - Returns: 두 노드가 같은 집합에 속해 있으면 true, 그렇지 않으면 false
        mutating func isConnected(_ node1: Int, _ node2: Int) -> Bool {
            return find(node1) == find(node2)
        }
        
        /// 배열 인덱스 기준을 지정하는 열거형
        enum ArrayIndexBase {
            case zero(nodeCount: Int)
            case one(nodeCount: Int)
            
            var arraySize: Int {
                switch self {
                case .zero(let nodeCount):
                    return nodeCount
                case .one(let nodeCount):
                    return nodeCount + 1
                }
            }
            
            var addtinalIndex: Int {
                switch self {
                case .zero:
                    return 0
                case .one:
                    return 1
                }
            }
        }
    }

    
    mutating func makeBridge() {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                guard identifiedMap[row][col] != 0 else { continue }
                let coordinate = Coordinate(row: row, col: col, distance: 0)
                makeBridge(coordinate: coordinate, source: identifiedMap[row][col])
            }
        }
    }
    
    struct Heap<Element: Comparable> {
        private let comparator: (Element, Element) -> Bool
        private(set) var storage: [Element] = []
        
        init(comparator: @escaping (Element, Element) -> Bool) {
            self.comparator = comparator
        }
        
        var isEmpty: Bool {
            storage.isEmpty
        }
        
        func peek() -> Element? {
            storage.first
        }
        
        /// - Complexity: O(log n)
        mutating func insert(_ element: Element) {
            storage.append(element)
            let insertedIndex = storage.count - 1
            siftUp(startIndex: insertedIndex)
        }
        
        mutating private func siftUp(startIndex: Int) {
            var currentIndex = startIndex
            
            while hasHigherPriorityThanParent(index: currentIndex) {
                let parentIndex = parentIndex(childIndex: currentIndex)
                storage.swapAt(currentIndex, parentIndex)
                currentIndex = parentIndex
            }
        }
        
        
        private func hasHigherPriorityThanParent(index: Int) -> Bool {
            guard index < storage.endIndex else { return false }
            
            let parentIndex = parentIndex(childIndex: index)
            let parentElement = storage[parentIndex]
            let childElement = storage[index]
            
            return comparator(childElement, parentElement)
        }
        
        mutating func pop() -> Element? {
            guard !storage.isEmpty else { return nil }
            
            guard storage.count != 1 else { return storage.removeLast()}
            
            let lastIndex = storage.count - 1
            
            storage.swapAt(0, lastIndex)
            let result = storage.removeLast()
            
            siftDown(currentIndex: 0)
            
            return result
        }
        
        private mutating func siftDown(currentIndex: Int) {
            var swapIndex = currentIndex
            var isSwap = false
            let leftIndex = leftChildIndex(parentIndex: currentIndex)
            let rightIndex = rightChildIndex(parentIndex: currentIndex)
            
            if hasHigherPriorityThanParent(index: leftIndex) {
                swapIndex = leftIndex
                isSwap = true
            }
            
            if rightIndex < storage.endIndex && comparator(storage[rightIndex], storage[swapIndex]) {
                swapIndex = rightIndex
                isSwap = true
            }
            
            if isSwap {
                storage.swapAt(swapIndex, currentIndex)
                siftDown(currentIndex: swapIndex)
            }
        }
        
        static func minHeap() -> Self{
            self.init(comparator: <)
        }
        
        static func maxHeap() -> Self{
            self.init(comparator: >)
        }
        
        // MARK: Index 관련 함수들
        private func leftChildIndex(parentIndex: Int) -> Int {
            parentIndex * 2 + 1
        }
        
        private func rightChildIndex(parentIndex: Int) -> Int {
            parentIndex * 2 + 2
        }
        
        private func parentIndex(childIndex: Int) -> Int {
            (childIndex - 1) / 2
        }
    }

    
    mutating func makeIdentifiedMap() {
        var id = 1
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                guard inputMap[row][col] == 1 && !isMigrated[row][col] else {
                    continue
                }
                
                isMigrated[row][col] = true
                identifiedMap[row][col] = id
                visit(coordinate: Coordinate(row: row, col: col, distance: 0), id: id)
                id += 1
                islandCount += 1
            }
        }
    }
    
    private mutating func makeBridge(coordinate: Coordinate, source: Int) {
        let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, 1), (0, -1)]
        
        for direction in directions {
            var current = coordinate
            var lenght = 0
            current.row += direction.0
            current.col += direction.1
            
            while current.isValidCoordinate(rowSize: rowSize, colSize: colSize) {
                let currentId = identifiedMap[current.row][current.col]
                
                if currentId != 0 && currentId != source && lenght > 1 {
                    let bridge = Bridge(linkedIsland: [source, currentId], lenght: lenght)
                    bridges.append(bridge)
                    break
                }
                
                if currentId != 0 {
                    break
                }
                
                current.row += direction.0
                current.col += direction.1
                lenght += 1
            }
        }
    }
    
    private mutating func visit(coordinate: Coordinate, id: Int) {
        for neighbor in coordinate.neighbors(rowSize: rowSize, colSize: colSize) {
            guard !isMigrated[neighbor.row][neighbor.col] && inputMap[neighbor.row][neighbor.col] == 1 else { continue }
            isMigrated[neighbor.row][neighbor.col] = true
            identifiedMap[neighbor.row][neighbor.col] = id
            visit(coordinate: neighbor, id: id)
        }
    }
    
    struct Bridge: Comparable {
        static func < (lhs: Solver17472.Bridge, rhs: Solver17472.Bridge) -> Bool {
            lhs.lenght < rhs.lenght
        }
        
        var linkedIsland: [Int] = []
        var lenght: Int = 0
    }
    
    struct Coordinate {
        var row: Int
        var col: Int
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
