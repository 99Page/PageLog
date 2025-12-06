var problem = Problem1439()
problem.solve()

struct Problem1439 {
    func solve() {
        let string = [Character](readLine()!)
        
        var lastCharacter: Character = "2"
        var zeroCount = 0
        var oneCount = 0
        
        for c in string {
            if c != lastCharacter {
                if c == "1" {
                    oneCount += 1
                } else {
                    zeroCount += 1
                }
            }
            
            lastCharacter = c
        }
        
        print(min(zeroCount, oneCount))
    }
}
