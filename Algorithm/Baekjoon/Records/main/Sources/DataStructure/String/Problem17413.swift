struct Problem17413 {
    
    var string = ""
    
    mutating func solve() {
        read()
        print(flip())
    }
    
    mutating func flip() -> String {
        var result = ""
        var stack: [Character] = []
        
        var isTag = false
        
        for char in string {
            if char == "<" {
                result.append(contentsOf: String(stack).reversed())
                stack.removeAll()
                isTag = true
                result.append(char)
                continue
            } else if char == ">" {
                isTag = false
                result.append(char)
                continue
            }
            
            if isTag {
                result.append(char)
            } else {
                if char == " " {
                    result.append(contentsOf: String(stack).reversed())
                    stack.removeAll()
                    result.append(char)
                } else {
                    stack.append(char)
                }
            }
        }
        
        result.append(contentsOf: String(stack).reversed())
        
        return result
    }
    
    mutating func read() {
        string = readLine()!
    }
}

