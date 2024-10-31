struct Solver2629 {
    let weightCount: Int
    let weights: [Int]
    let beadCount: Int
    let beads: [Int]
    
    // 0~39_999는 음수
    // 40_000는 0
    // 40_001~80_000까지는 양수
    var isVisited: [Bool] = Array(repeating: false, count: 80_001)
    
    let arraySize = 80_001
    let zeroIndex = 40_000
    
    
    init() {
        self.weightCount = Int(readLine()!)!
        self.weights = readArray()
        
        self.beadCount = Int(readLine()!)!
        self.beads = readArray()
    }
    
    mutating func solve() {
        isVisited[zeroIndex] = true
        
        for weight in weights {
            var visitStack: [Int] = []
            
            for index in 0..<arraySize {
                if isVisited[index] {
                    var nextIndex = index + weight
                    
                    if isValidRange(nextIndex) {
                        visitStack.append(nextIndex)
                    }
                    
                    nextIndex = index - weight
                    
                    if isValidRange(nextIndex) {
                        visitStack.append(nextIndex)
                    }
                }
            }
            
            for visit in visitStack {
                isVisited[visit] = true
            }
        }
        
        var result: [Bool] = []
        
        for bead in beads {
            result.append(isVisited[bead+zeroIndex])
        }
        
        print(result.joinedString())
    }
    
    private func isValidRange(_ index: Int) -> Bool {
        index >= 0 && index < arraySize
    }
}

private extension Array where Element == Bool {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map { $0 ? "Y" : "N" }.joined(separator: separator)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

