var solver = Solver4991()
solver.solve()

struct Solver4991 {
    var room: [[Character]] = []
    var nodes: [[Int]] = []
    var rowSize = 0
    var colSize = 0
    
    let cleanSpace: Character = "."
    let dirtySpace: Character = "*"
    let filledSpace: Character = "x"
    let robotStartPosition: Character = "o"
    
    var isCleaningTerminal: Bool {
        rowSize == 0 && colSize == 0
    }
    
    mutating func solve() {
        cleaningRooms()
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
        var label = 1
        nodes = room.map { $0.map { _ in 0 } }
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if room[row][col] == dirtySpace || room[row][col] == robotStartPosition {
                    nodes[row][col] = label
                    label += 1
                }
            }
        }
    }
    
    private mutating func cleaningRoom() {
        let edges = makeEdges()
        let dirtyRoom = countDirtyRoom()
        let nodeCount = dirtyRoom + 1
        let kruskal = KruskalSolver.findMinTotalWeight(edges: edges, arrayIndexBase: .one(nodeCount: nodeCount), nodeCount: nodeCount)
        print(kruskal)
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

    /// Kruskal 알고리즘을 이용해 MST 가중치 합을 계산하는 구조체
    struct KruskalSolver {

        /// 주어진 간선 정보와 노드 수를 바탕으로 최소 신장 트리의 가중치 합을 구하는 함수
        /// - Parameters:
        ///   - edges: 정렬되지 않은 가중치가 있는 간선들의 배열.
        ///   - arrayIndexBase: UnionFind에서 사용하는 배열의 시작 인덱스 베이스
        ///   - nodeCount: 그래프의 노드 개수
        /// - Returns: 최소 신장 트리의 총 가중치
        static func findMinTotalWeight(edges: [Edge], arrayIndexBase: UnionFindSolver.ArrayIndexBase, nodeCount: Int) -> Int {
            let sortedEdges = edges.sorted()

            var unionFinder = UnionFindSolver(arrayIndexBase: arrayIndexBase)
            var connectCount = 0
            var totalWeight = 0

            for edge in sortedEdges {
                /// 두 노드가 연결되지 않았다면 연결
                if !unionFinder.isConnected(edge.source, edge.destination) {
                    unionFinder.union(edge.source, edge.destination)
                    connectCount += 1
                    totalWeight += edge.weight
                    print("link \(edge.source)-\(edge.destination) sum \(totalWeight)")
                }

                /// 모든 노드가 연결되면 종료
                if connectCount == nodeCount - 1 {
                    break
                }
            }
            
            if connectCount != nodeCount - 1 {
                return -1
            }

            return totalWeight
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
            let arraySize = arrayIndexBase.arraySize + arrayIndexBase.addtinalIndex
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

