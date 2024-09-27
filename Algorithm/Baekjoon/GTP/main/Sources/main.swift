
var solver = Solver17825()
solver.solve()

/// 4개의 말
struct Solver17825 {
    
    let diceValues: [Int]
    
    private let horseCount = 4
    
    let points: [Int] = [
        0, 2, 4, 6, 8, 10,
        12, 14, 16, 18, 20,
        22, 24, 26, 28, 30,
        32, 34, 36, 38, 40,
        13, 16, 19, 25,
        22, 24,
        28, 27, 26,
        30, 35
        
    ]
    
    init() {
        self.diceValues = readArray()
    }
    
    mutating func solve() {
        let initialPositions = [0, 0, 0, 0]
        
    }
    
    mutating func move(horseIndex: Int, turn: Int, points: Int) {
        
        var newPoints = points
        
        (0..<horseCount).forEach { index in
            move(horseIndex: index, turn: turn + 1, points: newPoints)
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

