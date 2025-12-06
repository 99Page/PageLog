//4 4
//1111
//1111
//1111
//1111

//4 4
//1100
//0110
//0111
//0011

//2 3
//111
//111

//3 2
//11
//11
//11
struct Solver1915 {
    var contRow: [[Int]] = []
    var contCol: [[Int]] = []
    var map: [[Character]]
    var maxSquare: [[Int]]
    let n: Int
    let m: Int
    
    var visitCount = 0
    
    init() {
        let sizeInput: [Int] = readArray()
        n = sizeInput[0]
        m = sizeInput[1]
        
        contRow = Array(repeating: Array(repeating: -1, count: m), count: n)
        contCol = Array(repeating: Array(repeating: -1, count: m), count: n)
        map = []
        maxSquare = Array(repeating: Array(repeating: 0, count: m), count: n)
    }
    
    mutating func solve() {
        readMap()
        fillContColArray()
        fillContRowArray()
        findLargestSquare()
    }
    
    private mutating func findLargestSquare() {
        var largests = 0
        
        for row in (0..<n).reversed() {
            for col in (0..<m).reversed() {
                let current = min(contRow[row][col], contCol[row][col])
                
                if current > 0 {
                    maxSquare[row][col] = 1
                    largests = max(maxSquare[row][col], largests)
                }
                
                if isValidRange(row: row+1, col: col+1) {
                    maxSquare[row][col] = min(maxSquare[row+1][col+1] + 1, current)
                    largests = max(maxSquare[row][col], largests)
                }
            }
        }
        
        print(largests * largests)
    }
    
    private func minContValue(row: Int, col: Int) -> Int {
        min(contRow[row][col], contCol[row][col])
    }
    
    private mutating func fillContColArray() {
        for row in 0..<n {
            for col in 0..<m {
                if contCol[row][col] == -1 {
                    let _ = fillContinusColArray(row: row, col: col)
                }
            }
        }
    }
    
    private mutating func fillContRowArray() {
        for col in 0..<m {
            for row in 0..<n {
                if contRow[row][col] == -1 {
                    let _ = fillContinusRowArray(row: row, col: col)
                }
            }
        }
    }
    
    private mutating func fillContinusRowArray(row: Int, col: Int) -> Int {
        guard isValidRange(row: row, col: col) else { return 0 }
        visitCount += 1
        if map[row][col] == "1" {
            let value = fillContinusRowArray(row: row + 1, col: col) + 1
            contRow[row][col] = value
            return value
        } else {
            contRow[row][col] = 0
            return 0
        }
    }
    
    
    private mutating func fillContinusColArray(row: Int, col: Int) -> Int {
        guard isValidRange(row: row, col: col) else { return 0 }
        
        visitCount += 1
        if map[row][col] == "1" {
            let value = fillContinusColArray(row: row, col: col + 1) + 1
            contCol[row][col] = value
            return value
        } else {
            contCol[row][col] = 0
            return 0
        }
    }
    
    private func isValidRange(row: Int, col: Int) -> Bool {
        (0..<n).contains(row) && (0..<m).contains(col)
    }
    
    private mutating func readMap() {
        (0..<n).forEach { _ in
            let line = readLine()!
            map.append(Array(line))
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


