/// 미확인 도착지(BOJ 9370) 풀이
/// - Note: S, G, H에서 각각 다익스트라를 수행한 뒤,
///         `distS[x] == min(distS[g]+w(g,h)+distH[x], distS[h]+w(g,h)+distG[x])` 인 후보만 출력합니다.

var problem = Problem9370()
problem.solve()

/// 문제 전체를 해결하는 타입
/// - Important: 다익스트라 계산은 원본 가중치 그대로 3회 수행합니다.
struct Problem9370 {

    // MARK: Inputs
    var nodeCount = 0
    var edgeCount = 0
    var destinationCount = 0

    var startNode = 0
    var pass1 = 0
    var pass2 = 0

    var edges: [[DijkstraSolver.Edge]] = []
    var destCandidates: [Int] = []

    // MARK: Entry

    /// 테스트 케이스를 읽고 각 케이스를 해결합니다.
    mutating func solve() {
        guard let tStr = readLine(), let testCase = Int(tStr) else { return }

        for _ in 0..<testCase {
            readNMT()
            readSGH()
            readEdges()
            readDestCandidatesFlexible()
            selectDestinations()
        }
    }

    // MARK: Core

    /// 목적지 후보 중 조건(최단경로가 g–h 포함)을 만족하는 노드만 출력합니다.
    /// - Note: S, G, H 세 출발점에서 다익스트라를 수행합니다.
    mutating func selectDestinations() {
        var dj = DijkstraSolver(edges: edges, arrayIndexBase: .one(nodeCount: nodeCount))

        let distS = dj.solve(startNode: startNode)
        let distG = dj.solve(startNode: pass1)
        let distH = dj.solve(startNode: pass2)

        // g–h 간선 가중치(여러 개 있으면 최소값 사용)
        let ghWeight: Int = {
            let wg1 = edges[safe: pass1]?.compactMap { $0.destination == pass2 ? $0.cost : nil }.min()
            let wg2 = edges[safe: pass2]?.compactMap { $0.destination == pass1 ? $0.cost : nil }.min()
            return min(wg1 ?? .max, wg2 ?? .max)
        }()

        var result: [Int] = []
        for x in destCandidates {
            guard x >= 0, x < distS.count else { continue }
            guard distS[x] != .max, distG[x] != .max || distH[x] != .max else { continue }
            guard pass1 >= 0, pass1 < distS.count, pass2 >= 0, pass2 < distS.count else { continue }
            guard ghWeight != .max else { continue }

            // S->G->(g-h)->H->x  또는  S->H->(h-g)->G->x
            let viaGH = safeAdd(safeAdd(distS[pass1], ghWeight), distH[x])
            let viaHG = safeAdd(safeAdd(distS[pass2], ghWeight), distG[x])

            if distS[x] == min(viaGH, viaHG) {
                result.append(x)
            }
        }

        result.sort()
        print(result.joinedString())
    }

    // MARK: Reading

    /// 목적지 후보를 한 줄 다건/여러 줄 혼합 입력에도 안전하게 읽습니다.
    mutating func readDestCandidatesFlexible() {
        destCandidates.removeAll(keepingCapacity: true)
        while destCandidates.count < destinationCount {
            let arr: [Int] = readArray()
            if arr.isEmpty { break }
            destCandidates.append(contentsOf: arr)
        }
        if destCandidates.count > destinationCount {
            destCandidates.removeSubrange(destinationCount..<destCandidates.count)
        }
    }

    /// 간선 정보를 읽습니다(무방향).
    mutating func readEdges() {
        for _ in 0..<edgeCount {
            let a: [Int] = readArray()
            guard a.count >= 3 else { return }
            let src = a[0], dest = a[1], weight = a[2]

            let e1 = DijkstraSolver.Edge(source: src, destination: dest, cost: weight)
            let e2 = DijkstraSolver.Edge(source: dest, destination: src, cost: weight)
            if src >= 0, src < edges.count { edges[src].append(e1) }
            if dest >= 0, dest < edges.count { edges[dest].append(e2) }
        }
    }

    /// S, G, H를 읽습니다.
    mutating func readSGH() {
        let input: [Int] = readArray()
        guard input.count >= 3 else { return }
        startNode = input[0]
        pass1 = input[1]
        pass2 = input[2]
    }

    /// N, M, T를 읽고 그래프를 초기화합니다.
    mutating func readNMT() {
        let input: [Int] = readArray()
        guard input.count >= 3 else { return }
        nodeCount = input[0]
        edgeCount = input[1]
        destinationCount = input[2]
        edges = Array(repeating: [], count: nodeCount + 1)
        destCandidates.removeAll(keepingCapacity: true)
    }

    // MARK: Utils

    /// 정수 덧셈의 오버플로우를 방지합니다. 하나라도 `.max`면 `.max`를 반환합니다.
    @inline(__always)
    func safeAdd(_ a: Int, _ b: Int) -> Int {
        if a == .max || b == .max { return .max }
        let limit = Int.max - a
        return b > limit ? .max : a + b
    }

    // MARK: Dijkstra & Heap

    /// 다익스트라 최단경로 계산기
    /// - Note: 배열 인덱스 기준(0/1)을 NodeCount로 지정할 수 있습니다.
    struct DijkstraSolver {

        private let arrayIndexBase: NodeCount
        var edges: [[Edge]]

        init(edges: [[Edge]], arrayIndexBase: NodeCount) {
            self.arrayIndexBase = arrayIndexBase
            self.edges = edges
        }

        /// 시작 노드로부터 모든 노드까지의 최단거리를 계산합니다.
        /// - Complexity: O((N+M) log N)
        mutating func solve(startNode: Int) -> [Int] {
            let size = arrayIndexBase.arraySize
            guard startNode >= 0, startNode < size else {
                return Array(repeating: .max, count: size)
            }
            var costs = Array(repeating: Int.max, count: size)
            var visited = Array(repeating: false, count: size)
            costs[startNode] = 0

            var pq = Heap<Node>.minHeap()
            pq.insert(Node(index: startNode, cost: 0))

            while !pq.isEmpty {
                guard let node = pq.pop() else { break }
                let u = node.index
                if visited[u] { continue }
                visited[u] = true

                for e in edges[safe: u] ?? [] {
                    let here = costs[u]
                    guard here != .max else { continue }
                    let newCost = here > (Int.max - e.cost) ? Int.max : here + e.cost
                    if newCost < costs[e.destination] {
                        costs[e.destination] = newCost
                        pq.insert(Node(index: e.destination, cost: newCost))
                    }
                }
            }
            return costs
        }

        /// 배열 인덱스 기준
        enum NodeCount {
            case zero(nodeCount: Int)
            case one(nodeCount: Int)

            var arraySize: Int {
                switch self {
                case .zero(let n): return n
                case .one(let n):  return n + 1
                }
            }
        }

        /// 간선 모델
        struct Edge: Comparable {
            static func < (lhs: Edge, rhs: Edge) -> Bool { lhs.cost < rhs.cost }
            let source: Int
            let destination: Int
            let cost: Int
        }

        /// 우선순위 큐에 담는 노드
        struct Node: Comparable {
            let index: Int
            let cost: Int
            static func < (lhs: Node, rhs: Node) -> Bool { lhs.cost < rhs.cost }
        }
    }

    /// 이진 힙(우선순위 큐)
    /// - Important: `siftUp` 시 index == 0의 부모 접근을 차단하도록 가드합니다.
    struct Heap<Element: Comparable> {
        private let comparator: (Element, Element) -> Bool
        private(set) var elements: [Element] = []

        init(comparator: @escaping (Element, Element) -> Bool) {
            self.comparator = comparator
        }

        var isEmpty: Bool { elements.isEmpty }
        func peek() -> Element? { elements.first }

        /// - Complexity: O(log n)
        mutating func insert(_ element: Element) {
            elements.append(element)
            siftUp(from: elements.count - 1)
        }

        mutating func pop() -> Element? {
            guard !elements.isEmpty else { return nil }
            if elements.count == 1 { return elements.removeLast() }
            elements.swapAt(0, elements.count - 1)
            let res = elements.removeLast()
            siftDown(from: 0)
            return res
        }

        // MARK: Heapify

        private mutating func siftUp(from i: Int) {
            var idx = i
            while hasHigherPriorityThanParent(index: idx) {
                let p = parentIndex(of: idx)
                elements.swapAt(idx, p)
                idx = p
            }
        }

        private func hasHigherPriorityThanParent(index: Int) -> Bool {
            guard index > 0, index < elements.endIndex else { return false }
            let p = parentIndex(of: index)
            return comparator(elements[index], elements[p])
        }

        private mutating func siftDown(from i: Int) {
            var current = i
            while true {
                let l = leftChildIndex(of: current)
                let r = rightChildIndex(of: current)
                var candidate = current

                if l < elements.endIndex, comparator(elements[l], elements[candidate]) {
                    candidate = l
                }
                if r < elements.endIndex, comparator(elements[r], elements[candidate]) {
                    candidate = r
                }
                if candidate == current { break }
                elements.swapAt(candidate, current)
                current = candidate
            }
        }

        // MARK: Index helpers

        private func leftChildIndex(of i: Int) -> Int { i * 2 + 1 }
        private func rightChildIndex(of i: Int) -> Int { i * 2 + 2 }
        private func parentIndex(of i: Int) -> Int { (i - 1) / 2 }

        static func minHeap() -> Self { .init(comparator: <) }
        static func maxHeap() -> Self { .init(comparator: >) }
    }
}

// MARK: - IO Helpers

/// 공백 구분 숫자/문자열 배열을 읽습니다. 줄이 비면 `[]`를 반환합니다.
private func readArray<T: LosslessStringConvertible>() -> [T] {
    guard let line = readLine() else { return [] }
    return line.split(separator: " ").compactMap { T(String($0)) }
}

/// Array 안전 인덱싱
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < endIndex else { return nil }
        return self[index]
    }
}

/// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합합니다.
/// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
/// - Returns: 결합된 문자열
private extension Array where Element: LosslessStringConvertible {
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
