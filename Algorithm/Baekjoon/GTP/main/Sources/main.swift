//
//  main.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 9/19/24.
//

import Foundation

/// Conditions
/// [] 상어는 이동 후 냄새를 뿌린다. k번 후에 없어진다.
/// [] 이동은 냄새가 없는 칸. 그런 칸이 없으면 자신이 냄새가 있는 칸
/// [] 이동 가능한 경우가 여러개면 상어 각자의 우선 순위에 따라
/// [] 같은 같에 상어가 있는 경우 숫자가 큰 쪽이 죽음
/// 1번 상어만 남을 때까지 몇초가 걸리는가?

var solver = Solver19237()
solver.solve()

struct Solver19237 {
    
    let rowSize: Int
    let colSize: Int
    let smellTime: Int
    let maxSharkCount = 1000
    
    var newMap: [[MapInfo]]
    var map: [[MapInfo]]
    
    var sharks: [Shark]
    var remainSharkCount: Int
    var sharkCount: Int
    
    init() {
        self.map = []
        
        let input: [Int] = readArray() // input을 먼저 읽어와 저장
        self.rowSize = input[0]
        self.colSize = input[0]
        sharkCount = input[1]
        remainSharkCount = sharkCount
        self.smellTime = input[2]
        
        let map: [[Int]] = readGrid(rowSize)
        
        sharks = Array(repeating: .mock, count: sharkCount)
        
        self.map = Array(repeating: Array(repeating: .mock, count: colSize), count: rowSize)
        
        for i in 0..<rowSize {
            for j in 0..<colSize {
                let sharkNum = map[i][j]
                
                if sharkNum > 0 {
                    let sharkIndex = sharkNum - 1
                    sharks[sharkIndex].coordinate = Coordinate(row: i, col: j)
                    sharks[sharkIndex].isAlive = true
                    sharks[sharkIndex].sharkNum = sharkNum
                    
                    self.map[i][j] = MapInfo(sharkNum: sharkNum, remainSmellTime: smellTime + 1)
                }
            }
        }
        
        self.newMap = self.map
        
        let initialDirectionInput: [Int] = readArray()
        
        for (index, directionInput) in initialDirectionInput.enumerated() {
            sharks[index].currentDirection = Direction(value: directionInput)
        }
        
        (0..<sharkCount).forEach { index in
            sharks[index].priority = SharkPriority()
        }
    }
    
    mutating func solve() {
        let count = moveSharks()
        print(count)
    }
    
    mutating func moveSharks() -> Int {
        var moveCount = 0
        
        while !(moveCount > 1000 || remainSharkCount == 1) {
            discountSmell()
            newMap = map
            
            for sharkIndex in sharks.indices {
                moveShark(shark: sharks[sharkIndex])
            }
            
            moveCount += 1
            
            map = newMap
        }
        
        return moveCount <= 1000 ? moveCount : -1
    }
    
    private mutating func removeDeadSharks() {
        self.sharks = sharks.filter({ $0.isAlive })
    }
    
    mutating func discountSmell() {
        for i in 0..<rowSize {
            for j in 0..<colSize {
                handleSmell(i: i, j: j)
            }
        }
    }
    
    private mutating func handleSmell(i: Int, j: Int) {
        /// 이동 전에 냄새를 먼저 처리하기때문에
        if map[i][j].remainSmellTime > 0 {
            map[i][j].remainSmellTime -= 1
            
            if map[i][j].remainSmellTime == 0 {
                map[i][j].sharkNum = 0
            }
        }
    }
    
    mutating func moveShark(shark: Shark) {
        guard shark.isAlive else { return }
        
        let nextCoordinates = shark.coordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize)
        var validCoordinates: [Coordinate] = []
        
        /// 냄새가 없는 곳부터 우선적으로 찾습니다.
        for nextCoordinate in nextCoordinates {
            let row = nextCoordinate.row
            let col = nextCoordinate.col
            
            if isSmellEmpty(row: row, col: col) {
                validCoordinates.append(nextCoordinate)
            }
        }
        
        guard validCoordinates.isEmpty else {
            moveSharkByPrioirty(shark: shark, coordiantes: validCoordinates)
            return
        }
        
        /// 자기 자신이 냄새인 곳을 찾습니다.
        for nextCoordinate in nextCoordinates {
            if isSmellOf(shark: shark, coordinate: nextCoordinate) {
                validCoordinates.append(nextCoordinate)
            }
        }
        
        moveSharkByPrioirty(shark: shark, coordiantes: validCoordinates)
    }
    
    private mutating func moveSharkByPrioirty(shark: Shark, coordiantes: [Coordinate]) {
        guard !coordiantes.isEmpty else {
            fatalError("coordinates 배열이 비어있음.")
        }
        
        let currentDirection = shark.currentDirection
        let priority = shark.priority[currentDirection]
        
        var direction: Direction = .up
        var target = coordiantes[0]
        
        for directionPriority in priority {
            var isUpdated: Bool = false
            
            for coordiante in coordiantes {
                let nextDirection =  shark.coordinate.findDirectionByCurrent(next: coordiante)
                if directionPriority == nextDirection {
                    target = coordiante
                    direction = directionPriority
                    isUpdated = true
                    break
                }
            }
            
            if isUpdated {
                break
            }
        }
        
        /// 이동할 좌표에 냄새의 지속시간이 초기값과 같은 경우, 숫자가 낮은 상어가 이미 이동한 경우입니다.
        /// 따라서 죽어야합니다.
        if newMap[target.row][target.col].remainSmellTime == smellTime + 1 {
            sharks[shark.sharkIndex].isAlive = false
            remainSharkCount -= 1

            
        } else {
            let mapInfo = MapInfo(sharkNum: shark.sharkNum, remainSmellTime: smellTime + 1)
            newMap[target.row][target.col] = mapInfo
     
            sharks[shark.sharkIndex].coordinate = target
            sharks[shark.sharkIndex].currentDirection = direction
        }
    }
    
    
    private func isSmellEmpty(row: Int, col: Int) -> Bool {
        return map[row][col].remainSmellTime == 0 || map[row][col].remainSmellTime == smellTime + 1
    }
    
    private func isSmellOf(shark: Shark, coordinate: Coordinate) -> Bool {
        map[coordinate.row][coordinate.col].sharkNum == shark.sharkNum
    }
    
    
    
    struct Shark {
        var currentDirection: Direction
        var sharkNum: Int
        var coordinate: Coordinate
        var priority: SharkPriority
        var isAlive: Bool = false
        
        var sharkIndex: Int {
            sharkNum - 1
        }
        
        static let mock = Shark(currentDirection: .up, sharkNum: 0, coordinate: Coordinate(row: 0, col: 0), priority: .mock)
    }
    
    
    struct SharkPriority {
        var upPriority: [Direction]
        var downPriority: [Direction]
        var leftPriority: [Direction]
        var rightPriority: [Direction]
        
        static let mock: SharkPriority = SharkPriority(mocks: [])
        
        private init(mocks: [Direction]) {
            upPriority = []
            downPriority = []
            leftPriority =  []
            rightPriority = []
        }
        
        init() {
            upPriority = []
            downPriority = []
            leftPriority = []
            rightPriority = []
            
            let upPriorityValue: [Int] = readArray()
            upPriority = upPriorityValue.map({ Direction(value: $0) })
            
            let downPriorityValue: [Int] = readArray()
            downPriority = downPriorityValue.map({ Direction(value: $0) })
            
            let leftPriorityValue: [Int] = readArray()
            leftPriority = leftPriorityValue.map({ Direction(value: $0) })
            
            let rightPriorityValue: [Int] = readArray()
            rightPriority = rightPriorityValue.map({ Direction(value: $0) })
        }
        
        subscript(index: Direction) -> [Direction] {
            switch index {
            case .up:
                return upPriority
            case .down:
                return downPriority
            case .left:
                return leftPriority
            case .right:
                return rightPriority
            }
        }
    }

    struct Coordinate {
        let row: Int
        let col: Int
        let arrayIndexBase: ArrayIndexBase
        
        init(row: Int, col: Int, arrayIndexBase: ArrayIndexBase = .zero) {
            self.row = row
            self.col = col
            self.arrayIndexBase = arrayIndexBase
        }
        
        func findDirectionByCurrent(next: Coordinate) -> Direction {
            if self.row + 1 == next.row {
                return .down
            } else if self.row - 1 == next.row {
                return .up
            } else if self.col + 1 == next.col {
                return .right
            } else {
                return .left
            }
        }
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositions(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                Coordinate(row: row, col: col - 1),
                Coordinate(row: row, col: col + 1),
                Coordinate(row: row - 1, col: col),
                Coordinate(row: row + 1, col: col)
            ]
            
            /// 유효한 좌표만 필터링하여 반환
            return candidates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
            
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


    struct MapInfo {
        var sharkNum: Int
        var remainSmellTime: Int
        
        static let mock = MapInfo(sharkNum: 0, remainSmellTime: 0)
    }

    enum Direction {
        case up
        case down
        case left
        case right
        
        init(value: Int) {
            switch value {
            case 1:
                self = .up
            case 2:
                self = .down
            case 3:
                self = .left
            case 4:
                self = .right
            default:
                self = .up
            }
        }
    }
}

func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
        
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}

func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
