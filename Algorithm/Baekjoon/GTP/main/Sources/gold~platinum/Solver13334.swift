
/// 배열을 순회하면서 n^2 경우의 수를 줄이는 방법.
/// 이런 문제에서 내가 자주 사용하는 방법은 두가지가 있다.
///
/// 1. 한번 순회했던 정보를 저장해서 넘어가거나 -> Queue/Stack
/// 2. 배열 간의 Shortcut을 만들거주거나
///
/// 이 문제는 Shorcut을 만들기 적합한 문제는 아니다.
/// 따라서 1번 방법이 더 적합했고, 크기에 따른 비교가 가능하니 PQ 활용도 가능하다.
///
/// 아래 문제는 보통 `Line sweeping` 문제라고 부른다. 
struct Solver13334 {
    let peopleCount: Int
    let edges: [Edge]
    let length: Int
    
    init() {
        self.peopleCount = Int(readLine()!)!
        
        let edgeInputs: [[Int]] = readGrid(peopleCount)
        
        self.length = Int(readLine()!)!
        var edges: [Edge] = []
        
        for edgeInput in edgeInputs {
            let start = min(edgeInput[0], edgeInput[1])
            let end = max(edgeInput[0], edgeInput[1])
            
            if end - start <= length {
                edges.append(Edge(start: start, end: end))
            }
        }
        
        self.edges = edges
    }
    
    func solve() {
        let sortedEdges = edges.sorted()
        var result: Int = 0
        
        var heap = Heap<Edge> {
            if $0.start != $1.start {
                return $0.start < $1.start
            } else {
                return $0.end < $1.end
            }
        }
        
        for sortedEdge in sortedEdges {
            let endOfLine = sortedEdge.end
            let line = Edge(start: endOfLine - length, end: endOfLine)
            
            if sortedEdge.start >= line.start {
                heap.insert(sortedEdge)
            }
            
            
            while heap.peek()?.start ?? .max < line.start {
                let pop = heap.pop()
            }
            
            result = max(heap.storage.count, result)
        }
        
        print(result)
    }
    
    struct Edge: Comparable {
        static func < (lhs: Solver13334.Edge, rhs: Solver13334.Edge) -> Bool {
            if lhs.end != rhs.end {
                return lhs.end < rhs.end
            } else {
                return lhs.start < rhs.start
            }
        }
        
        let start: Int
        let end: Int
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


extension Array where Element: Comparable {
    /// 주어진 연산을 사용하 이진 탐색을 합니다. comparator의 연산자에 따라 lowerBound, upperBound가 결정되는 것에 주의합니다.
    /// 배열은 미리 정렬되어 있어야 합니다.
    /// - Parameters:
    ///   - value: 탐색할 값
    ///   - comparator: 비교 조건을 정의하는 클로저 (기본값으로 `<=` 사용)
    /// - Returns: 주어진 값보다 큰 첫 번째 요소의 인덱스, 없으면 배열의 크기
    func binarySearch(_ value: Element, using comparator: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count
        
        while low < high {
            let mid = (low + high) / 2
            if comparator(self[mid], value) {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}


