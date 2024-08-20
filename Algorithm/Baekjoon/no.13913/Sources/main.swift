import Foundation

/// Backtracking으로 접근하는 건 좋았는데
/// 탐색 문제를 재귀적으로 풀려고하니까 콜스택 문제가 있었다.
/// 탐색이 필요하면 Queue 사용을 먼저 고려하자.
/// Queue + BFS 사용 우선 고려! 
let maxXCoordinate = 100000
let minXCoordinate = 0

let initialValue = MoveInfo(cost: .max, lastPosition: -1, currentPosition: -1)
var moveInfos: [MoveInfo] = Array(repeating: initialValue, count: maxXCoordinate + 1)
var queue = Queue<MoveInfo>()

let (n, k) = readNAndK()

findMinCostMove()

print(moveInfos[k].cost)
printPath()

func printPath() {
    var paths: [Int] = []
    var currentPosition = moveInfos[k]
    
    
    while currentPosition.cost != 0 {
        paths.append(currentPosition.currentPosition)
        let newIndex = currentPosition.lastPosition
        currentPosition = moveInfos[newIndex]
    }
 
    paths.append(currentPosition.currentPosition)
    
    for value in paths.reversed() {
        print(value, terminator: " ")
    }
}



func findMinCostMove() {
    let start = MoveInfo(cost: 0, lastPosition: n, currentPosition: n)
    moveInfos[n] = start
    queue.enqueue(start)
    
    while !queue.isEmpty {
        let current = queue.dequeue()!
        
        let newCost = current.cost + 1
        let lastPosition = current.currentPosition
        
        let doubledPosition = current.currentPosition * 2
        let nextPosition = current.currentPosition + 1
        let previousPosition = current.currentPosition - 1
        
        if isInsertable(index: doubledPosition, newCost: newCost) {
            let moveInfo = MoveInfo(cost: newCost, lastPosition: lastPosition, currentPosition: doubledPosition)
            updateMoveInfos(moveInfo: moveInfo)
            queue.enqueue(moveInfo)
        }
        
        if isInsertable(index: nextPosition, newCost: newCost) {
            let moveInfo = MoveInfo(cost: newCost, lastPosition: lastPosition, currentPosition: nextPosition)
            updateMoveInfos(moveInfo: moveInfo)
            queue.enqueue(moveInfo)
        }
        
        if isInsertable(index: previousPosition, newCost: newCost) {
            let moveInfo = MoveInfo(cost: newCost, lastPosition: lastPosition, currentPosition: previousPosition)
            updateMoveInfos(moveInfo: moveInfo)
            queue.enqueue(moveInfo)
        }
    }
}

func updateMoveInfos(moveInfo: MoveInfo) {
    let index = moveInfo.currentPosition
    moveInfos[index] = moveInfo
}

func isInsertable(index: Int, newCost: Int) -> Bool {
    isValidIndex(index) && newCost < moveInfos[index].cost
}

func isValidIndex(_ index: Int) -> Bool {
    index >= minXCoordinate && index <= maxXCoordinate
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



struct MoveInfo: Comparable {
    static func < (lhs: MoveInfo, rhs: MoveInfo) -> Bool {
        lhs.cost < rhs.cost
    }
    
    let cost: Int
    let lastPosition: Int
    let currentPosition: Int
}
