struct Solver2637 {
    let finalProduct: Int
    let combinations: [[Int: Int]]
    var baseProducts: [[Int: Int]] = []
    
    init() {
        self.finalProduct = Int(readLine()!)!
        let modularCount = Int(readLine()!)!
        
        var combinations: [[Int: Int]] = Array(repeating: [:], count: modularCount + 1)
        self.baseProducts = Array(repeating: [:], count: modularCount + 1)
        
        (0..<modularCount).forEach { _ in
            let input: [Int] = readArray()
            let x = input[0]
            let y = input[1]
            let k = input[2]
            
            combinations[x][y] = k
        }
        
        self.combinations = combinations
    }
    
    mutating func solve() {
        let baseProductOfFinalProduct = countBaseProduct(finalProduct)
        let sortedBaseProduct = baseProductOfFinalProduct.sorted { $0.key < $1.key }
        
        var output: [String] = []
        
        for (key, value) in sortedBaseProduct {
            output.append("\(key) \(value)")
        }
        
        print(output.joined(separator: "\n"))
    }
    
    private mutating func countBaseProduct(_ number: Int) -> [Int: Int] {
        guard hasCombination(number) else {
            return [number: 1] // 기초제품
        }
        
        guard baseProducts[number].isEmpty else { return baseProducts[number] }
        
        for (key, value) in combinations[number] {
            let baseProduct = countBaseProduct(key)
            addBaseProduct(to: number, multiplier: value, baseProduct: baseProduct)
        }
        
        return baseProducts[number]
    }
    
    private mutating func addBaseProduct(to number: Int, multiplier: Int, baseProduct: [Int: Int]) {
        for (key, value) in baseProduct {
            baseProducts[number][key, default: 0] += value * multiplier
        }
    }
    
    private func hasCombination(_ number: Int) -> Bool {
        !combinations[number].isEmpty
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


