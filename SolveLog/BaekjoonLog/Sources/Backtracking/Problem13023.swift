struct Problem13023 {
    
    var friends: [Int: Set<Int>] = [:]
    var visited: Set<Int> = []
    var nodeCount = 0
    var result = 0
    
    mutating func solve() {
        let metaInput: [Int] = readArray()
        nodeCount = metaInput[0]
        let unionCount = metaInput[1]
        
        
        (0..<unionCount).forEach { _ in
            let unionInput: [Int] = readArray()
            let node1 = unionInput[0]
            let node2 = unionInput[1]
            
            friends[node1, default: []].insert(node2)
            friends[node2, default: []].insert(node1)
        }
        
        for i in 0..<nodeCount {
            visited.insert(i)
            visit(i)
            visited.remove(i)
        }
        
        print(result)
    }
    
    mutating func visit(_ node: Int) {
        guard result == 0 else { return }
        
        guard visited.count < 5 else {
            result = 1
            return
        }
        
        for friend in friends[node, default: []] where !visited.contains(friend) {
            visited.insert(friend)
            visit(friend)
            visited.remove(friend)
        }
    }
    
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


