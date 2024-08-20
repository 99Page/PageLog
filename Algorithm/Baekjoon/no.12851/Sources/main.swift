import Foundation

let minX = 0
let maxX = 100000
var queue = Queue<Int>()
let (n, k) = readNAndK()

/// index: 위치
/// value: 해당 위치까지의 최소 cost
var costs: [Int] = Array(repeating: .max, count: maxX + 1)

var minCostOnTarget: Int = .max
var minCostWayCount: Int = 0

findResult()

if n == k {
    print(0)
    print(1)
} else {
    print(minCostOnTarget)
    print(minCostWayCount)
}

func findResult() {
    costs[n] = 0
    queue.enqueue(n)
    
    while !queue.isEmpty {
        let currentX = queue.dequeue()!

        let nextCost = costs[currentX] + 1
        
        let doubledX = currentX * 2
        let nextX = currentX + 1
        let previousX = currentX - 1
        
        /// 조건을 중복적으로 확인하지 않으려고
        /// 일단 Queue에 넣고 dequeue 시 업데이트하는 방법을 고려해봤는데
        /// 문제를 확인하기 어렵다.
        /// Queue를 사용해서 BFS를 처리할 때는
        /// enqueue할 때 enqueue 가능한 지 조건을 확인하고
        /// 모든 정보를 업데이트 해주는게 낫다.
        ///
        /// 재귀를 사용할 때는 flag를 사용해서 깔끔해지는데
        /// Queue는 그냥 방문시 조건 확인하자.
        if isInsertable(index: doubledX, cost: nextCost) {
            costs[doubledX] = nextCost
            queue.enqueue(doubledX)
            updateResult(x: doubledX)
        }
        
        if isInsertable(index: nextX, cost: nextCost) {
            costs[nextX] = nextCost
            queue.enqueue(nextX)
            updateResult(x: nextX)
        }
        
        if isInsertable(index: previousX, cost: nextCost) {
            costs[previousX] = nextCost
            queue.enqueue(previousX)
            updateResult(x: previousX)
        }
    }
}

func updateResult(x: Int) {
    guard x == k else { return }
    
    if costs[x] < minCostOnTarget {
        minCostOnTarget = costs[x]
        minCostWayCount = 1
    } else if costs[x] == minCostOnTarget {
        minCostWayCount += 1
    }
}

func isInsertable(index: Int, cost: Int) -> Bool {
    isValid(index: index) && cost <= costs[index]
}

func isValid(index: Int) -> Bool {
    index >= minX && index <= maxX
}


func readNAndK() -> (Int, Int) {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    
    let n = Int(splitedInput[0])!
    let k = Int(splitedInput[1])!
    
    return (n, k)
}

struct Queue<Element> {
    private var inStack = [Element]()
    private var outStack = [Element]()
    
    var isEmpty: Bool {
        inStack.isEmpty && outStack.isEmpty
    }
    
    mutating func enqueue(_ newElement: Element) {
        inStack.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if outStack.isEmpty {
            outStack = inStack.reversed()
            inStack.removeAll()
        }
        
        return outStack.popLast()
    }
}

