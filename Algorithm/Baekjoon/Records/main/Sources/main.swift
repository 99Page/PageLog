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
        let contactRegex = "^(100+1+|01)+$"
        
        if pattern.matchesRegex(contactRegex) {
            print("YES")
        } else {
            print("NO")
        }
    }
    
    mutating func read() {
        testCase = Int(readLine()!)!
    }
}


private extension String {
    func matchesRegex(_ pattern: String) -> Bool {
        guard !self.isEmpty else { return false }
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let fullRange = NSRange(location: 0, length: self.utf16.count)
            let match = regex.firstMatch(in: self, options: [], range: fullRange)
            return match != nil
            
        } catch {
            return false
        }
    }
}
