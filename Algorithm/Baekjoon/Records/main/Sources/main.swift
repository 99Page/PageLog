var solver = Solver2504()
solver.solve()

struct Solver2504 {
    
    let parentheses: [Character]
    
    init() {
        self.parentheses = [Character](readLine()!)
    }
    
    mutating func solve() {
        var array: [Character] = []
        var values: [Int] = []
        var total = 0
        
        /// 연산의 순서를 따져보면
        ///
        /// ( () [[]] ) << 이게 마지막.
        for p in parentheses {
            print(p)
            switch p {
            case "(":
                array.append(p)
            case ")":
                
            case "[":
                array.append(p)
            case "]":
               
            default:
                break
            }
        }
        
        print(total)
    }
    
    struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()
        
        /// 큐가 비어있는지 여부를 반환합니다.
        var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }

        /// 큐에 있는 요소의 총 개수를 반환합니다.
        var count: Int {
            inStack.count + outStack.count
        }

        /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
        var peek: Element? {
            if outStack.isEmpty {
                return inStack.first
            }
            return outStack.last
        }
        
        /// 큐에 요소를 추가합니다.
        /// - Parameter newElement: 큐에 삽입할 요소
        mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }
        
        /// 큐에서 요소를 제거하고 반환합니다.
        /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
        mutating func dequeue() -> Element? {
            if outStack.isEmpty {
                outStack = inStack.reversed()
                inStack.removeAll()
            }
            
            return outStack.popLast()
        }
    }

}
