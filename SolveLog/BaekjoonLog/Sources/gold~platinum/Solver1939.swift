//6 6
//1 2 6
//2 3 5
//3 6 4
//1 4 10
//4 5 9
//5 6 8
//1 6

//3 2
//1 2 2
//2 3 4
//1 3

//6 6
//1 2 1
//2 3 2
//3 6 3
//1 4 4
//4 5 5
//5 6 6
//1 6

struct Solver1939 {
    let islandCount: Int
    let bridgeCount: Int
    var bridges: [[Edge]] = []
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.islandCount = firstLineInput[0]
        self.bridgeCount = firstLineInput[1]
    }
    
    mutating func solve() {
        readEdges()
        findMaxWeight()
    }
    
    mutating func findMaxWeight() {
        let targetInput: [Int] = readArray()
        
        let source = targetInput[0]
        let destination = targetInput[1]
        
        var isVisited: [Bool] = Array(repeating: false, count: islandCount + 1)
        var maxWeights: [Int] = Array(repeating: .min, count: islandCount + 1)
        
        var islandQueue = Heap<Node>.maxHeap()
        maxWeights[source] = 0
        
        let sourceIsland = Node(current: source, minWeight: .max)
        islandQueue.insert(sourceIsland)
        
        while !islandQueue.isEmpty {
            let island = islandQueue.pop()!
            
            if isVisited[island.current] { continue }
            isVisited[island.current] = true
            
            for bridge in bridges[island.current] {
                let dest = bridge.destination
                let newMinWeight = min(island.minWeight, bridge.maxWeight)
                
                if newMinWeight > maxWeights[dest] {
                    maxWeights[dest] = newMinWeight
                    let nextIsland = Node(current: bridge.destination, minWeight: newMinWeight)
                    islandQueue.insert(nextIsland)
                }
            }
        }
        
        print(maxWeights[destination])
    }
    
    mutating func readEdges() {
        self.bridges = Array(repeating: [], count: islandCount + 1)
        
        (0..<bridgeCount).forEach { _ in
            let bridgeInput: [Int] = readArray()
            let source = bridgeInput[0]
            let destination = bridgeInput[1]
            let maxWeight = bridgeInput[2]
            
            let edge1 = Edge(source: source, destination: destination, maxWeight: maxWeight)
            bridges[source].append(edge1)
            
            let edge2 = Edge(source: destination, destination: source, maxWeight: maxWeight)
            bridges[destination].append(edge2)
        }
    }
    
    struct Node: Comparable {
        static func < (lhs: Solver1939.Node, rhs: Solver1939.Node) -> Bool {
            lhs.minWeight < rhs.minWeight
        }
        
        let current: Int
        let minWeight: Int
    }
    
    struct Edge {
        let source: Int
        let destination: Int
        let maxWeight: Int
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


