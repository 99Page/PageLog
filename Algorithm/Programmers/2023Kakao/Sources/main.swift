import Foundation


solution([15])

func solution(_ numbers:[Int64]) -> [Int] {
    
    var binaries: [String] = []
    var result: [Int] = []
    var numOfNodes: [Int] = []
    
    var i = 0
    while true {
        let cur: Int = Int(pow(Double(2), Double(i))) - 1
        
        if cur >= 10000000000000000 {
            break
        }
        
        numOfNodes.append(cur)
        i += 1
    }
    
    
    for number in numbers {
        let cur = String(number, radix: 2)
        print(cur)
        var curString = ""
        
        let i = numOfNodes.lowerBound(target: cur.count)
        
        for _ in 0..<numOfNodes[i]-cur.count {
            curString.append("0")
        }
        
        curString.append(cur)
        
        binaries.append(curString)
    }
    
    for binary in binaries {
//        print("\(binary)")
        if check(binary) {
            result.append(1)
        } else {
            result.append(0)
        }
    }
    
    return result
}

func check(_ binary: String) -> Bool {
    var cur: String = binary
    var next: String = ""
    
    
    while !(cur.count == 1) {
        var start = 0
//        print("\(cur)")
        
        while start < cur.count {
            let group = cur.substring(from: start, to: start + 2)
            
            if (group.at(0) == "1" || group.at(2) == "1") && group.at(1) == "0" {
                return false
            } else {
                next.append(group.at(1))
            }
            
            next.append(cur.at(start + 3))
            start += 4
        }
        
        cur = next
        next = ""
    }
    
    return true
}

//solution([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
//solution([63, 111, 95])

extension Array where Element: Comparable {
    
    func lowerBound(target: Element) -> Int {
        var e = self.count
        var s = 0
        while(s < e) {
            let m = (s+e) / 2
            if (self[m] as Element >= target) {
                e = m
            } else {
                s = m+1
            }
        }
        
        return e;
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
        
        // at으로 특정 위치의 문자열 고른 후 Charatcter타입으로 바꿀 때 이용.
    func at(_ index: Int) -> String {
        return self.substring(from: index, to: index)
    }
}

struct DoubleStackQueue<Element> {
    private var inbox: [Element] = []
    private var outbox: [Element] = []
    
    var isEmpty: Bool{
        return inbox.isEmpty && outbox.isEmpty
    }
    
    var count: Int{
        return inbox.count + outbox.count
    }
    
    var front: Element? {
        return outbox.last ?? inbox.first
    }
    
    init() { }
    
    init(_ array: [Element]) {
        self.init()
        self.inbox = array
    }
    
    mutating func enqueue(_ n: Element) {
        inbox.append(n)
    }
    
    mutating func dequeue() -> Element {
        if outbox.isEmpty {
            outbox = inbox.reversed()
            inbox.removeAll()
        }
        return outbox.removeLast()
    }
}

extension DoubleStackQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init()
        inbox = elements
    }
}
