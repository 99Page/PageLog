var solver = Solver5214()
solver.solve()


//3 2 1
//1 2

struct Solver5214 {
    
    let stationCount: Int
    let relationCount: Int
    let hyperTubeCount: Int
    let finalStation: Int
    
    var hyperTubes: [Set<Int>] = []
    
    var visitCounts: [Int]
    var usedHyperTubes: [Bool]
    
    let defaultVisitCount = -1
    
    init() {
        let conditions: [Int] = readArray()
        self.stationCount = conditions[0]
        self.relationCount = conditions[1]
        self.hyperTubeCount = conditions[2]
        self.finalStation = stationCount
        
        var hyperTubes: [Set<Int>] = []
        
        (0..<hyperTubeCount).forEach { _ in
            let hyperTube: Set<Int> =  Set([Int](readArray()))
            hyperTubes.append(hyperTube)
        }
        
        self.hyperTubes = hyperTubes
        
        self.visitCounts = Array(repeating: defaultVisitCount, count: stationCount + 1)
        visitCounts[1] = 1
        
        self.usedHyperTubes = Array(repeating: false, count: hyperTubeCount)
    }
    
    mutating func solve() {
        move()
        print(visitCounts[finalStation])
    }
    
    mutating func move() {
        var moveCount = 2
        
        var oldVisitStations: Set<Int> = [1]
        var newVisitStations: Set<Int> = [1]
        
        var loopCount = 0
        
        while loopCount < hyperTubeCount {
            
            
            var isHyperTubeUsed = false
            
            for (index, hyperTube) in hyperTubes.enumerated() {
                guard canUsingHyperTube(hyperTube: hyperTube, visitStations: oldVisitStations) else { continue }
                guard !usedHyperTubes[index] else { continue }
                
                move(using: hyperTube, moveCount: moveCount, visitStations: &newVisitStations)
                usedHyperTubes[index] = true
                isHyperTubeUsed = true
            }
            
            moveCount += 1
            oldVisitStations = newVisitStations
            loopCount += 1
            
            if !isHyperTubeUsed { break }
            if oldVisitStations.contains(finalStation) { break }
        }
    }
    
    mutating func canUsingHyperTube(hyperTube: Set<Int>, visitStations: Set<Int>) -> Bool {
        !hyperTube.isDisjoint(with: visitStations)
    }
    
    mutating func move(using hyperTube: Set<Int>, moveCount: Int, visitStations: inout Set<Int>) {
        for station in hyperTube {
            guard visitCounts[station] == defaultVisitCount else { continue }
            visitCounts[station] = moveCount
            visitStations.insert(station)
        }
    }
    
    struct Station {
        let visitCount: Int
        let number: Int
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
