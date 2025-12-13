import Foundation

var problem = Problem1013()
problem.solve()

struct Problem1013 {
    var testCase = 0
    
    mutating func solve() {
        read()
        
        (0..<testCase).forEach { _ in
            checkValidPattern(readLine()!)
        }
    }
    
    mutating func checkValidPattern(_ pattern: String) {
        let splited = pattern
            .components(separatedBy: "01")
            .map { String($0) }
        
        var lastSplit = ""
        
        let regex1 = try! Regex("^10+$")
        let regex2 = try! Regex("^1+$")
        
        for split in splited {
            if split == "" {
                lastSplit = split
                continue
            }
            
            if !(split.contains(regex1) || split.contains(regex2)) {
                print("NO")
                return
            }
            
            if split.contains(regex2) && !lastSplit.contains(regex1) {
                print("NO")
                return
            }
            
            lastSplit = split
        }
        
        print("YES")
    }
    
    mutating func read() {
        testCase = Int(readLine()!)!
    }
}
