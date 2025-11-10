import Foundation

struct Problem25206 {
    
    var scoreByLevel: [String: Double] = [
        "A+" : 4.5,
        "A0" : 4.0,
        "B+" : 3.5,
        "B0" : 3.0,
        "C+" : 2.5,
        "C0" : 2.0,
        "D+" : 1.5,
        "D0" : 1.0,
        "F" : 0.0
    ]
    
    mutating func solve() {
        
        var sumOfScore = 0.0
        var sumCount = 0.0
        
        (0..<20).forEach { _ in
            let grade: [String] = readArray()
            let mul = Double(grade[1])!
            let level = grade[2]
            
            if level != "P" {
                let score = scoreByLevel[level, default: 0] * mul
                sumOfScore += score
                sumCount += mul
            }
        }
        
        let avgValue = (sumCount == 0 ? 0.0 : (sumOfScore / sumCount))
        let avg = String(format: "%.5f", avgValue)
        print(avg)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
