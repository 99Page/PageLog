
var solver = Solver2169()
solver.solve()

//3 3
//100 -29 -25
//-57 -33 99
//-11 77 15

/// 모든 케이스를 보면서 중복된 케이스를 줄여야한다. DFS + DP
/// 지금까지 봤던 문제와 다른 점은, 배열 이동의 방향성이 한개가 아니라는 점.
/// 어디서 왔느냐에 따라서 다음에 갈 수 있는 경로가 제한적이다.
///
/// 위로 갈 수 있는 경우는 없으니까
/// 왼쪽과 오른쪽의 mem을 별도로 관리해서 풀이?
///
struct Solver2169 {
    let rowSize: Int
    let colSize: Int
    let map: [[Int]]
    
    private let minCost = -2_000_000
    
    var cost: [[[Int]]]
    var isVisited: [[Bool]]
    
    init() {
        let input: [Int] = readArray()
        self.rowSize = input[0]
        self.colSize = input[1]
        
        self.map = readGrid(rowSize)
        
        
        let colCost: [Int] = Array(repeating: .min, count: colSize)
        let rowCost: [[Int]] = Array(repeating: colCost, count: rowSize)
        
        let directionCount = Direction.allCases.count
        self.cost = Array(repeating: rowCost, count: directionCount)
        
        let colVisit = Array(repeating: false, count: colSize)
        self.isVisited = Array(repeating: colVisit, count: rowSize)
        
        for direction in Direction.allCases {
            let targetCost = map[rowSize - 1][colSize - 1]
            cost[direction.rawValue][rowSize - 1][colSize - 1] = targetCost
        }
    }
    
    mutating func solve() {
        let initialCoordinate = Coordinate(row: 0, col: 0, distance: 0)
        isVisited[0][0] = true
        let result = search(coordinate: initialCoordinate, byDirection: .down)
        print(result)
    }
    
    mutating func search(coordinate: Coordinate, byDirection direction: Direction) -> Int {
        
        let row = coordinate.row
        let col = coordinate.col
        
        guard cost[direction.rawValue][row][col] == .min else {
            return cost[direction.rawValue][row][col]
        }
        
        var maxCost: Int = .min
        
        for nextCoordinate in coordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
            if !isVisited[nextCoordinate.row][nextCoordinate.col] {
                isVisited[nextCoordinate.row][nextCoordinate.col] = true
                let newDirection = nextCoordinate.findDirection(oldCoordinate: coordinate)
                let newCost = search(coordinate: nextCoordinate, byDirection: newDirection)
                maxCost = max(newCost, maxCost)
                isVisited[nextCoordinate.row][nextCoordinate.col] = false
            }
        }
        
        if maxCost != .min {
            cost[direction.rawValue][row][col] = map[row][col] + maxCost
        } else {
            cost[direction.rawValue][row][col] = minCost
        }
        
        return cost[direction.rawValue][row][col]
    }
    
    enum Direction: Int, CaseIterable {
        case left
        case right
        case down
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
        
        func findDirection(oldCoordinate: Coordinate) -> Direction {
            if oldCoordinate.row < self.row {
                return .down
            } else if oldCoordinate.col < self.col {
                return .right
            } else {
                return .left
            }
        }
        
        /// 현재 위치에서 이동할 수 있는 모든 유효한 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        /// 이동 가능한 방향은 상, 하, 좌, 우 및 대각선입니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 모든 방향으로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositionsIncludingDiagonals(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                // 상하좌우
                Coordinate(row: row, col: col - 1, distance: distance + 1), // 왼쪽
                Coordinate(row: row, col: col + 1, distance: distance + 1), // 오른쪽
                Coordinate(row: row - 1, col: col, distance: distance + 1), // 위쪽
                Coordinate(row: row + 1, col: col, distance: distance + 1), // 아래쪽
                
                // 대각선
                Coordinate(row: row - 1, col: col - 1, distance: distance + 1), // 왼쪽 위 대각선
                Coordinate(row: row - 1, col: col + 1, distance: distance + 1), // 오른쪽 위 대각선
                Coordinate(row: row + 1, col: col - 1, distance: distance + 1), // 왼쪽 아래 대각선
                Coordinate(row: row + 1, col: col + 1, distance: distance + 1)  // 오른쪽 아래 대각선
            ]
            
            /// 유효한 좌표만 필터링하여 반환
            return candidates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
        }
        
        /// 현재 위치에서 이동할 수 있는 하, 좌, 우의 다음 위치를 반환합니다. 위로 가는 방향은 없습니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositions(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                Coordinate(row: row, col: col - 1, distance: distance + 1),
                Coordinate(row: row, col: col + 1, distance: distance + 1),
                Coordinate(row: row + 1, col: col, distance: distance + 1)
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

private func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
    
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}
