
var solver = Solver2211()
solver.solve()

//4 4
//1 2 2
//2 3 5
//2 4 6
//1 4 7
struct Solver2211 {
    
    let computerCount: Int
    let lineCount: Int
    var lineQueue: Heap<Edge>
    let edges: [Edge]
    var edgeGrid: [[Edge]]
    
    init() {
        let firstLineInput: [Int] = readArray()
        var edges: [Edge] = []
        
        var lineQueue: Heap<Edge> = .minHeap()
        self.computerCount = firstLineInput[0]
        self.lineCount = firstLineInput[1]
        
        
        var edgeGrid: [[Edge]] = Array(repeating: [], count: firstLineInput[0] + 1)
        
        (0..<lineCount).forEach { index in
            let edgeInput: [Int] = readArray()
            let edge = Edge(edgeIndex: index, source: edgeInput[0], destination: edgeInput[1], cost: edgeInput[2])
            
            lineQueue.insert(edge)
            edges.append(edge)
            edgeGrid[edge.source].append(edge)
            edgeGrid[edge.destination].append(edge)
        }
        
        self.edges = edges
        self.edgeGrid = edgeGrid
        self.lineQueue = lineQueue
    }
    
    mutating func solve() {
        var dijkstartSolver = DijkstraSolver(edges: edgeGrid, arrayIndexBase: .one(nodeCount: computerCount))
        var unionFindSolver = UnionFindSolver(arrayIndexBase: .one(nodeCount: computerCount))
        let result = dijkstartSolver.solve(startNode: 1)
        
        print(result.0)
        
        var additionalEdge = 0
        
        var linkOutput = ""
        
        for edgeIndex in result.1 {
            let edge = edges[edgeIndex]
            print(edge)
            unionFindSolver.union(edge.source, edge.destination)
            linkOutput.append("\(edge.source) \(edge.destination)\n")
        }
        
        while !lineQueue.isEmpty {
            let edge = lineQueue.pop()!
            
            if !unionFindSolver.isConnected(edge.destination, edge.source) {
                additionalEdge += 1
                unionFindSolver.union(edge.source, edge.destination)
                linkOutput.append("\(edge.source) \(edge.destination)")
            }
        }
        
        print(linkOutput)
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

    struct DijkstraSolver {
        private let arrayIndexBase: NodeCount
        var lines: [[Edge]]
        
        init(edges: [[Edge]], arrayIndexBase: NodeCount) {
            self.arrayIndexBase = arrayIndexBase
            self.lines = edges
        }
        
        mutating func solve(startNode: Int) -> ([Int], [Int]) {
            let costSize = arrayIndexBase.arraySize
            var costs: [Int] = Array(repeating: .max, count: costSize)
            var isVisited: [Bool] = Array(repeating: false, count: costSize)
            costs[startNode] = 0
            
            var selectedEdges: Set<Int> = []
            
            var nodePriorityQueue = Heap<Node>.minHeap()
            let startNode = Node(index: startNode, cost: 0)
            nodePriorityQueue.insert(startNode)
            
            while !nodePriorityQueue.isEmpty {
                let node = nodePriorityQueue.pop()!
                let currentNode = node.index
                
                if isVisited[currentNode] {
                    continue
                }
                
                isVisited[currentNode] = true
                
                for edge in lines[currentNode] {
                    if costs[currentNode] != .max && costs[currentNode] + edge.cost < costs[edge.destination] {
                        costs[edge.destination] = costs[currentNode] + edge.cost
                        let nextNode = Node(index: edge.destination, cost: costs[currentNode] + edge.cost)
                        nodePriorityQueue.insert(nextNode)
                    }
                }
            }
            
            return (costs, Array(selectedEdges))
        }
        
        enum NodeCount {
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
        }
        
        struct Node: Comparable {
            let index: Int
            let cost: Int
            
            static func < (lhs: Node, rhs: Node) -> Bool {
                return lhs.cost < rhs.cost
            }
        }
    }
    
    struct Edge: Comparable {
        static func < (lhs: Edge, rhs: Edge) -> Bool {
            lhs.cost < rhs.cost
        }
        
        let edgeIndex: Int
        let source: Int
        let destination: Int
        let cost: Int
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

}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


