
var solver = Solver21609()
solver.solve()

/// 빈 블록 -2
/// 검은 블록 -1
/// 무지개블록 0
/// 일반블록은 자연수
///
/// 중력작용: 오른쪽으로 이동
/// 반시계 구현? 행열 간의 스왑.
struct Solver21609 {
    let gridSize: Int
    let colorCount: Int

    var map: [[Int]]
    var score: Int = 0
    
    init() {
        let input: [Int] = readArray()
        self.gridSize = input[0]
        self.colorCount = input[1]
        
        self.map = readGrid(gridSize)
    }
    
    mutating func solve() {
        while true {
            let blockGroups = findLargestBlockGroup()
            
            if blockGroups.count > 1 {
                getScoreByRemoving(blockGroups)
            } else {
                break
            }
            
            executeGravity()
            rotateCounterClockwise()
            executeGravity()
        }
        
        print(score)
    }
    
    mutating func rotateCounterClockwise() {
        var rotatedMap: [[Int]] = []
        
        for col in (0..<gridSize).reversed() {
            var rotatedRow: [Int] = []
            
            for row in (0..<gridSize) {
                rotatedRow.append(map[row][col])
            }
            
            rotatedMap.append(rotatedRow)
        }
        
        map = rotatedMap
    }
    
    mutating func executeGravity() {
        for col in (0..<gridSize) {
            executeGravity(inCol: col)
        }
    }
    
    mutating func executeGravity(inCol col: Int) {
        var gravityTargets: [Coordinate] = []
        
        for row in (0..<gridSize) {
            if map[row][col] != -1 {
                gravityTargets.append(Coordinate(row: row, col: col, distance: 0))
            } else {
                pull(blocks: gravityTargets, inFrontOf: Coordinate(row: row, col: col, distance: 0))
                gravityTargets = []
            }
        }
        
        /// 검은색 블록을 만나지 못해 아직 중력을 작용하지 않은 블록들을 끌어옵니다.
        pull(blocks: gravityTargets, inFrontOf: Coordinate(row: gridSize, col: col, distance: 0))
    }
    
    mutating func pull(blocks: [Coordinate], inFrontOf coordinate: Coordinate) {
        guard blocks.count > 0 else { return }
        
        var row = coordinate.row - 1
        var colorBlocks: [Coordinate] = []
        var colors: [Int] = []
        
        for block in blocks {
            if map[block.row][block.col] >= 0 {
                colorBlocks.append(block)
                colors.append(map[block.row][block.col])
            }
        }
        
        let emptyBlockCount = blocks.count - colorBlocks.count
        
        /// 최하단에 있는 블록이 배열의 마지막에 위치하니 역순으로 위치를 옮깁니다.
        for index in colorBlocks.indices.reversed() {
            map[row][coordinate.col] = colors[index]
            row -= 1
        }
        
        /// 남은 칸을 모두 빈 칸으로 변경합니다.
        for _ in 0..<emptyBlockCount {
            map[row][coordinate.col] = -2
            row -= 1
        }
    }
    
    /// 조건2번. 블록의 제거 및 B^2만큼의 점수
    mutating func getScoreByRemoving(_ blockGroups: [Coordinate]) {
        for coordinate in blockGroups {
            map[coordinate.row][coordinate.col] = -2
        }
        
        score += blockGroups.count * blockGroups.count
    }
    
    mutating func findLargestBlockGroup() -> [Coordinate] {
        let colVisit: [Bool] = Array(repeating: false, count: gridSize)
        var visit: [[Bool]] = Array(repeating: colVisit, count: gridSize)
        var searchResult = SearchResult()
        
        for row in (0..<gridSize) {
            for col in (0..<gridSize) {
                if map[row][col] > 0 && !visit[row][col] {
                    let coordinate = Coordinate(row: row, col: col, distance: 0)
                    let newSearchResult = searchBlock(coordinate: coordinate, color: map[row][col], visit: &visit)
                    selectValidSearchResult(current: &searchResult, new: newSearchResult)
                    
                    for rainbowBlock in newSearchResult.rainbowBlocks {
                        visit[rainbowBlock.row][rainbowBlock.col] = false
                    }
                }
            }
        }
        
        return searchResult.coordinates
    }
    
    mutating func selectValidSearchResult(current: inout SearchResult, new: SearchResult) {
        guard new.coordinates.count >= 2 else { return }
        
        if new.coordinates.count > current.coordinates.count {
            current = new
        } else if new.coordinates.count == current.coordinates.count {
            if new.rainbowBlocks.count > current.rainbowBlocks.count {
                current = new
            } else if new.rainbowBlocks.count == current.rainbowBlocks.count {
                current = new
            }
        }
    }
    
    mutating func searchBlock(coordinate: Coordinate, color: Int, visit: inout [[Bool]]) -> SearchResult {
        var visitQueue = Queue<Coordinate>()
        var searchResult = SearchResult()
        
        visitQueue.enqueue(coordinate)
        searchResult.coordinates.append(coordinate)
        visit[coordinate.row][coordinate.col] = true
        
        while !visitQueue.isEmpty {
            let currentCoordinate = visitQueue.dequeue()!
            
            for nextCoordinate in currentCoordinate.findValidNextPositions(rowSize: gridSize, colSize: gridSize) {
                if canEnqueue(visit: visit, coordinate: nextCoordinate, color: color) {
                    visit[nextCoordinate.row][nextCoordinate.col] = true
                    visitQueue.enqueue(nextCoordinate)
                    
                    searchResult.coordinates.append(nextCoordinate)
                    if map[nextCoordinate.row][nextCoordinate.col] == 0 {
                        searchResult.rainbowBlocks.append(nextCoordinate)
                    }
                }
            }
        }
        
        return searchResult
    }
    
    mutating func canEnqueue(visit: [[Bool]], coordinate: Coordinate, color: Int) -> Bool {
        !visit[coordinate.row][coordinate.col]
        && (map[coordinate.row][coordinate.col] == color || map[coordinate.row][coordinate.col] == 0)
    }
    
    struct SearchResult {
        var rainbowBlocks: [Coordinate] = []
        var coordinates: [Coordinate] = []
        
        var normalBlockCount: Int { coordinates.count - rainbowBlocks.count }
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
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositions(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                Coordinate(row: row, col: col - 1, distance: distance + 1),
                Coordinate(row: row, col: col + 1, distance: distance + 1),
                Coordinate(row: row - 1, col: col, distance: distance + 1),
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

private func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
    
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


