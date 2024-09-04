import Foundation

/// 다익스트라 알고리즘을 사용하여 그래프의 최단 경로를 계산하는 구조체
///
/// 다익스트라 알고리즘은 다음과 같은 상황에서 주로 사용됩니다:
/// - **양의 가중치를 가진 간선이 있는 그래프**: 다익스트라 알고리즘은 모든 간선의 가중치가 양수인 경우에 사용됩니다.
/// - **한 정점에서 다른 정점까지의 최단 경로를 효율적으로 계산**: 다익스트라 알고리즘은 단일 출발점에서 시작하여 모든 다른 정점까지의 최단 경로를 계산할 수 있습니다.
/// - **음수 가중치가 없는 그래프에서**: 다익스트라 알고리즘은 음수 가중치를 지원하지 않기 때문에, 모든 간선의 가중치가 양수여야 합니다.
struct DijkstraSolver {
    
    private let arrayIndexBase: NodeCount
    var edges: [[Edge]]
    
    init(edges: [[Edge]], arrayIndexBase: NodeCount) {
        self.arrayIndexBase = arrayIndexBase
        self.edges = edges
    }
    
    mutating func solve(startNode: Int) -> [Int] {
        let costSize = arrayIndexBase.arraySize
        var costs: [Int] = Array(repeating: .max, count: costSize)
        var isVisited: [Bool] = Array(repeating: false, count: costSize)
        costs[startNode] = 0
        
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
            
            for edge in edges[currentNode] {
                if costs[currentNode] != .max && costs[currentNode] + edge.cost < costs[edge.destination] {
                    costs[edge.destination] = costs[currentNode] + edge.cost
                    let nextNode = Node(index: edge.destination, cost: costs[currentNode] + edge.cost)
                    nodePriorityQueue.insert(nextNode)
                }
            }
        }
        
        return costs
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
    
    struct Edge: Comparable {
        static func < (lhs: DijkstraSolver.Edge, rhs: DijkstraSolver.Edge) -> Bool {
            lhs.cost < rhs.cost
        }
        
        let destination: Int
        let cost: Int
    }
    
    struct Node: Comparable {
        let index: Int
        let cost: Int
        
        static func < (lhs: Node, rhs: Node) -> Bool {
            return lhs.cost < rhs.cost
        }
    }
}
