
var solver = Solver()
solver.solve()

//3 6
//1 1 1 2
//1 2 2 2
//2 2 1 3
//1 3 2 3
//1 1 3 3
//3 3 2 1
struct Solver {
    
    // false는 꺼진 곳
    // true는 켜진 곳
    var light: [[Bool]]
    
    // false는 방문 전
    // true는 방문
    var visitMap: [[Bool]]
    
    var lampSwitch: [Coordinate: [Coordinate]]
    
    let gridSize: Int
    
    init() {
        let input: [Int] = readArray()
        
        self.gridSize = input[0]
        
        light = Array(repeating: Array(repeating: false, count: gridSize + 1), count: gridSize + 1)
        light[1][1] = true
        
        visitMap = Array(repeating: Array(repeating: false, count: gridSize + 1), count: gridSize + 1)
        visitMap[1][1] = true
        
        let switchCount = input[1]
        
        lampSwitch = [:]
        
        (0..<switchCount).forEach { _ in
            let switchInput: [Int] = readArray()
            let source = Coordinate(row: switchInput[0], col: switchInput[1], distance: 0, arrayIndexBase: .one)
            let destination = Coordinate(row: switchInput[2], col: switchInput[3], distance: 0, arrayIndexBase: .one)
            
            if lampSwitch[source] == nil {
                lampSwitch[source] = [destination]
            } else {
                lampSwitch[source]?.append(destination)
            }
        }
    }
    
    /// 예외 상황
    /// * 최종적으로는 불이 켜지나, 옆 방을 방문한 당시에는 아닌 경우
    mutating func solve() {
        var queue = Queue<Coordinate>()
        
        var result = 1
        queue.enqueue(Coordinate(row: 1, col: 1, distance: 0, arrayIndexBase: .one))
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            if lampSwitch[current] != nil {
                let switches = lampSwitch[current]!
                for lightSwitch in switches {
                    turnOnLight(lightSwitch, count: &result)
                    
                    if isVisitable(lightSwitch) {
                        visitMap[lightSwitch.row][lightSwitch.col] = true
                        queue.enqueue(lightSwitch)
                    }
                }
            }
            
            for next in current.findValidNextPositions(rowSize: gridSize, colSize: gridSize) {
                if isVisitable(next) {
                    visitMap[next.row][next.col] = true
                    queue.enqueue(next)
                }
            }
        }
        
        print(result)
    }
    
    private mutating func turnOnLight(_ coordinate: Coordinate, count: inout Int) {
        guard !light[coordinate.row][coordinate.col] else { return }
        light[coordinate.row][coordinate.col] = true
        count += 1
    }
    
    private func isVisitable(_ coordinate: Coordinate) -> Bool {
        !visitMap[coordinate.row][coordinate.col]
        && light[coordinate.row][coordinate.col]
        && didVisitNeighbor(coordinate)
    }
    
    private func didVisitNeighbor(_ coordinate: Coordinate) -> Bool {
        for neigbor in coordinate.findValidNextPositions(rowSize: gridSize, colSize: gridSize) {
            if visitMap[neigbor.row][neigbor.col] {
                return true
            }
        }
        
        return false
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

    
    struct Coordinate: Hashable {
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
                Coordinate(row: row, col: col - 1, distance: distance), // 왼쪽
                Coordinate(row: row, col: col + 1, distance: distance), // 오른쪽
                Coordinate(row: row - 1, col: col, distance: distance), // 위쪽
                Coordinate(row: row + 1, col: col, distance: distance), // 아래쪽
                
                // 대각선
                Coordinate(row: row - 1, col: col - 1, distance: distance), // 왼쪽 위 대각선
                Coordinate(row: row - 1, col: col + 1, distance: distance), // 오른쪽 위 대각선
                Coordinate(row: row + 1, col: col - 1, distance: distance), // 왼쪽 아래 대각선
                Coordinate(row: row + 1, col: col + 1, distance: distance)  // 오른쪽 아래 대각선
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
                Coordinate(row: row, col: col - 1, distance: distance, arrayIndexBase: arrayIndexBase),
                Coordinate(row: row, col: col + 1, distance: distance, arrayIndexBase: arrayIndexBase),
                Coordinate(row: row - 1, col: col, distance: distance, arrayIndexBase: arrayIndexBase),
                Coordinate(row: row + 1, col: col, distance: distance, arrayIndexBase: arrayIndexBase)
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
        
        enum ArrayIndexBase: Hashable {
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

