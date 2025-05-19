
var solver = Solver()
solver.solve()

//3
//2 Z ABC
//2 ABC Z
//2 ZZ ABC

//5
//1 C
//2 A B
//3 A A A
//2 B A
//2 A C

//4
//2 APPLE BANANA
//4 APPLE APPLE BANANA BANANA
//3 APPLE APPLE KIWI
//3 APPLE APPLE APPLE

//3
//1 APPLE
//1 BANANA
//1 KIWI
struct Solver {
    let feeds: [String]
    let feedCount: Int
    
    init() {
        self.feedCount = Int(readLine()!)!
        
        var feeds: [String] = []
        
        (0..<feedCount).forEach { _ in
            var feed = readLine()!.split(separator: " ")
            feed.removeFirst()
            let feedString = feed.reduce(into: "", { $0 += String($1 + " ") })
            feeds.append(feedString)
        }
        
        self.feeds = feeds
    }
    
    mutating func solve() {
        let sortedFeeds = feeds.sorted()
        var oldFeed: [String] = Array(repeating: "", count: 15)
        var result: [String] = []
        
        for feed in sortedFeeds {
            let newFeed = feed.split(separator: " ")
            var prefix = ""
            
            for index in newFeed.indices {
                if oldFeed[index] != newFeed[index] {
                    result.append("\(prefix)\(newFeed[index])")
                }
                
                prefix += "--"
            }
            
            for index in 0..<15 {
                if index < newFeed.count {
                    oldFeed[index] = String(newFeed[index])
                } else {
                    oldFeed[index] = ""
                }
            }
        }
        
        let reduced = result.reduce(into: "") { $0 += "\($1)\n" }
        print(reduced)
    }
}
