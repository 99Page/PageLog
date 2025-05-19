var solver = Solver()
solver.solve()

struct Solver {
    let endDay: Int
    
    let time: [Int]
    let cost: [Int]
    
    var maxCost: [Int]
    
    let maxEndDay = 1016
    
    init() {
        self.endDay = Int(readLine()!)!
        
        var time: [Int] = [0]
        var cost: [Int] = [0]
        
        (0..<endDay).forEach { _ in
            let consultation: [Int] = readArray()
            time.append(consultation[0])
            cost.append(consultation[1])
        }
        
        self.time = time
        self.cost = cost
        self.maxCost = Array(repeating: 0, count: maxEndDay)
    }
    
    mutating func solve() {
        for day in 1...endDay {
            let consultationEndDay = day + time[day]
            maxCost[day] = max(maxCost[day - 1], maxCost[day])
            maxCost[consultationEndDay] = max(maxCost[consultationEndDay], maxCost[day] + cost[day])
        }
        
        maxCost[endDay + 1] = max(maxCost[endDay], maxCost[endDay + 1])
        print(maxCost[endDay + 1])
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

