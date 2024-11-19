//2
//2 0 0
//2 0 2

//Flush and Pull 예제
//5
//3 0 0
//3 0 1
//3 0 2
//2 0 0
//3 0 3

//Light color 예제
//3
//2 0 0
//3 0 0
//3 0 0

//Light color 2개 있는 케이스
//4
//2 0 0
//2 0 0
//3 0 0
//3 0 0

//12
//1 0 0
//2 1 0
//3 2 0
//1 0 0
//2 0 1
//3 0 2
//1 0 0
//2 1 0
//3 2 0
//1 0 0
//2 0 1
//3 0 2




/// [] 주어진 입력에 맞게 초록보드, 파랑보드의 빈 칸이 채워진다.
/// [] 한 줄이 다 채워지면, 해당 줄을 모두 비운다.
/// [] 비워진 공간만큼 이동시킨다.
/// [] 연한 곳에 있을 경우 해당 공간의 수만큼 아래공간을 비운다. 이 과정은 2번 작업이 모두 끝나면 진행된다.
struct Solver20061 {
    var greenBoard: [[Bool]]
    var blueBoard: [[Bool]]
    let commandCount: Int
    
    let narrowSize = 4
    let wideSize = 6
    
    var score = 0
    
    
    init() {
        
        let greenBoardRow: [Bool] = Array(repeating: false, count: narrowSize)
        self.greenBoard = Array(repeating: greenBoardRow, count: wideSize)
        
        let blueBoardRow: [Bool] = Array(repeating: false, count: wideSize)
        self.blueBoard = Array(repeating: blueBoardRow, count: narrowSize)
        
        self.commandCount = Int(readLine()!)!
    }
    
    /// 문제 해결을 위한 최초 시작점
    mutating func solve() {
        (0..<commandCount).forEach { _ in
            let commandInput: [Int] = readArray()
            let blockCommand = BlockCommand(
                blockType: commandInput[0],
                blockStartRow: commandInput[1],
                blockStartCol: commandInput[2]
            )
            
            executeCommand(blockCommand)
        }
        
      
        
        print(score)
        print(countRemainBlock())
    }
    
    func countRemainBlock() -> Int {
        var blockCount = 0
        
        for narrowIndex in 0..<narrowSize {
            for wideIndex in 0..<wideSize {
                if greenBoard[wideIndex][narrowIndex] {
                    blockCount += 1
                }
                
                if blueBoard[narrowIndex][wideIndex] {
                    blockCount += 1
                }
            }
        }
        
        return blockCount
    }
    
    mutating func executeCommand(_ blockCommand: BlockCommand) {
        fillBlock(blockCommand)
        
        flushAndPullBlockInGreenBlock()
        flushAndPullBlockInBlueBlock()
        
        executeLightGreenBoard()
        executeLightBlueBoard()
    }
    
    mutating func executeLightBlueBoard() {
        var colCount = 0
        
        for col in 0..<2 {
            var isIncreasedInThisCol = false
            
            for row in 0..<narrowSize {
                if blueBoard[row][col] {
                    if !isIncreasedInThisCol {
                        colCount += 1
                        isIncreasedInThisCol = true
                    }
                }
            }
        }
        
        for col in (wideSize-colCount..<wideSize).reversed() {
            for row in 0..<narrowSize {
                blueBoard[row][col] = false
            }
        }
        
        for _ in (wideSize-colCount..<wideSize).reversed() {
            pullBlueBoard(over: wideSize - 1)
        }
    }
    
    mutating func executeLightGreenBoard() {
        var rowCount = 0
        
        for row in 0..<2 {
            for col in 0..<narrowSize {
                if greenBoard[row][col] {
                    rowCount += 1
                    break
                }
            }
        }
        
        for row in (wideSize-rowCount..<wideSize).reversed() {
            for col in 0..<narrowSize {
                greenBoard[row][col] = false
            }
        }
        
        for _ in (wideSize-rowCount..<wideSize).reversed() {
            pullGreenBoard(over: wideSize - 1)
        }
    }
    
    mutating func flushAndPullBlockInBlueBlock() {
        var isFlushed = false
        
        for col in 0..<wideSize {
            let isFull = isFullRow(col: col)
            
            if isFull {
                isFlushed = true
                flushBlueBoard(col: col)
                pullBlueBoard(over: col)
                score += 1
            }
        }
        
        if isFlushed {
            flushAndPullBlockInBlueBlock()
        }
    }
    
    
    mutating func flushAndPullBlockInGreenBlock() {
        var isFlushed = false
        
        for row in 0..<wideSize {
            let isFull = isFullCol(row: row)
            
            if isFull {
                isFlushed = true
                flushGreenBoard(row: row)
                pullGreenBoard(over: row)
                score += 1
            }
        }
        
        if isFlushed {
            flushAndPullBlockInGreenBlock()
        }
    }
    
    func isFullCol(row: Int) -> Bool {
        var isFull = true
        
        for col in 0..<narrowSize {
            if !greenBoard[row][col] {
                isFull = false
            }
        }
        
        return isFull
    }
    
    func isFullRow(col: Int) -> Bool {
        var isFull = true
        
        for row in 0..<narrowSize {
            if !blueBoard[row][col] {
                isFull = false
            }
        }
        
        return isFull
    }
    
    mutating func pullGreenBoard(over row: Int) {
        for upperRow in (0..<row).reversed() {
            for col in 0..<narrowSize {
                if greenBoard[upperRow][col] {
                    greenBoard[upperRow][col] = false
                    greenBoard[upperRow + 1][col] = true
                }
            }
        }
    }
    
    mutating func pullBlueBoard(over col: Int) {
        for upperCol in (0..<col).reversed() {
            for row in 0..<narrowSize {
                if blueBoard[row][upperCol] {
                    blueBoard[row][upperCol] = false
                    blueBoard[row][upperCol + 1] = true
                }
            }
        }
    }
    
    mutating func flushGreenBoard(row: Int) {
        for col in 0..<narrowSize {
            greenBoard[row][col] = false
        }
    }
    
    mutating func flushBlueBoard(col: Int) {
        for row in 0..<narrowSize {
            blueBoard[row][col] = false
        }
    }
    
    mutating func fillBlock(_ blockCommand: BlockCommand) {
        fillBlockInGreenBlock(blockCommand)
        fillBlockInBlueBlock(blockCommand)
    }
    
    mutating func fillBlockInBlueBlock(_ blockCommand: BlockCommand) {
        var queue = Queue<[Coordinate]>()
        queue.enqueue(blockCommand.makeStartCoordinates(of: .blue))
        
        var lastCoordinates = blockCommand.makeStartCoordinates(of: .blue)
        
        while !queue.isEmpty {
            let currentCoordinates = queue.dequeue()!
            let nextCoordinates = currentCoordinates.map { Coordinate(row: $0.row, col: $0.col + 1, distance: 0) }
            lastCoordinates = currentCoordinates
            
            var canEnqueue: Bool = true
            
            for nextCoordinate in nextCoordinates {
                if !nextCoordinate.isValidCoordinate(rowSize: narrowSize, colSize: wideSize) || blueBoard[nextCoordinate.row][nextCoordinate.col] {
                    canEnqueue = false
                    break
                }
            }
            
            if canEnqueue {
                queue.enqueue(nextCoordinates)
            }
        }
        
        for lastCoordinate in lastCoordinates {
            blueBoard[lastCoordinate.row][lastCoordinate.col] = true
        }
    }
    
    mutating func fillBlockInGreenBlock(_ blockCommand: BlockCommand) {
        var queue = Queue<[Coordinate]>()
        queue.enqueue(blockCommand.makeStartCoordinates(of: .green))
        
        var lastCoordinates = blockCommand.makeStartCoordinates(of: .green)
        
        while !queue.isEmpty {
            let currentCoordinates = queue.dequeue()!
            let nextCoordinates = currentCoordinates.map { Coordinate(row: $0.row + 1, col: $0.col, distance: 0) }
            lastCoordinates = currentCoordinates
            
            var canEnqueue: Bool = true
            
            for nextCoordinate in nextCoordinates {
                if !nextCoordinate.isValidCoordinate(rowSize: wideSize, colSize: narrowSize) || greenBoard[nextCoordinate.row][nextCoordinate.col] {
                    canEnqueue = false
                    break
                }
            }
            
            if canEnqueue {
                queue.enqueue(nextCoordinates)
            }
        }
        
//        print("greenBoard: \(lastCoordinates)")
        for lastCoordinate in lastCoordinates {
            greenBoard[lastCoordinate.row][lastCoordinate.col] = true
        }
    }
    
    enum ColorBoard {
        case blue
        case green
    }
    
    struct BlockCommand {
        let blockType: Int
        let blockStartRow: Int
        let blockStartCol: Int
        
        func makeStartCoordinates(of colorBoard: ColorBoard) -> [Coordinate] {
            switch colorBoard {
            case .blue:
                return blueBoardStartCoordinates
            case .green:
                return greenBoardStartCoordinates
            }
        }
        
        var blueBoardStartCoordinates: [Coordinate] {
            switch blockType {
            case 1:
                return [Coordinate(row: blockStartRow, col: 0, distance: 0)]
            case 2:
                return [
                    Coordinate(row: blockStartRow, col: 0, distance: 0),
                    Coordinate(row: blockStartRow, col: 1, distance: 0)
                ]
            case 3:
                return [
                    Coordinate(row: blockStartRow, col: 0, distance: 0),
                    Coordinate(row: blockStartRow + 1, col: 0, distance: 0)
                ]
            default:
                return []
            }
        }
        
        var greenBoardStartCoordinates: [Coordinate] {
            switch blockType {
            case 1:
                return [Coordinate(row: 0, col: blockStartCol, distance: 0)]
            case 2:
                return [
                    Coordinate(row: 0, col: blockStartCol, distance: 0),
                    Coordinate(row: 0, col: blockStartCol + 1, distance: 0)
                ]
            case 3:
                return [
                    Coordinate(row: 0, col: blockStartCol, distance: 0),
                    Coordinate(row: 1, col: blockStartCol, distance: 0)
                ]
            default:
                return []
            }
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}



