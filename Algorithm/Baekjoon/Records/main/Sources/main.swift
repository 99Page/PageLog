
var solver = Solver1938()
solver.solve()

struct Solver1938 {
    
    let mapSize: Int
    let map: [[Character]]
    
    /// 첫번째 인덱스: 회전 상태. 0이면 가로, 1이면 세로
    /// 두번째 인덱스: row
    /// 세번째 인덱스: col
    var isVisited: [[[Bool]]]
    
    var result: Int = .max
    
    init() {
        self.mapSize = Int(readLine()!)!
        
        var map: [[Character]] = []
        
        (0..<mapSize).forEach { _ in
            let row = [Character](readLine()!)
            map.append(row)
        }
        
        self.map = map
        
        let gridIsVisited = Array(repeating: Array(repeating: false, count: mapSize), count: mapSize)
        self.isVisited = Array(repeating: gridIsVisited, count: 2)
    }
    
    mutating func solve() {
        let initialTree = findInitialTreeState()
        
        var visitQueue = Queue<(Tree, Int)>()
        
        visitQueue.enqueue((initialTree, 0))
        checkVisit(tree: initialTree)
        
        while !visitQueue.isEmpty {
            let current = visitQueue.dequeue()!
            let tree = current.0
            let count = current.1
            
            guard !isTreeRechedEnd(tree: tree) else {
                result = min(count, result)
                break
            }
            
            for nextTree in tree.findValidNextCoordinates(mapSize: mapSize) {
                if !isVisited[nextTree.rotateDirection][nextTree.center.row][nextTree.center.col] && canMoveTree(nextTree) {
                    checkVisit(tree: nextTree)
                    visitQueue.enqueue((nextTree, count + 1))
                }
            }
            
            if canRotateTree(tree) {
                var rotatedTree = tree
                rotatedTree.rotate()
                
                if !isVisited[rotatedTree.rotateDirection][rotatedTree.center.row][rotatedTree.center.col] && canMoveTree(rotatedTree) {
                    checkVisit(tree: rotatedTree)
                    visitQueue.enqueue((rotatedTree, count + 1))
                }
            }
        }
        
        print(result == .max ? 0 : result)
    }
    
    mutating func canMoveTree(_ tree: Tree) -> Bool {
        let treeCoordinates = tree.coordinates
        
        for treeCoordinate in treeCoordinates {
            if !treeCoordinate.isValidCoordinate(mapSize: mapSize) || map[treeCoordinate.row][treeCoordinate.col] == "1" {
                return false
            }
        }
        
        return true
    }
    
    mutating func checkVisit(tree: Tree) {
        isVisited[tree.rotateDirection][tree.center.row][tree.center.col] = true
    }
    
    func canRotateTree(_ tree: Tree) -> Bool {
        if tree.rotateDirection == 0 {
            return canRotateToVertical(tree)
        } else {
            return canRotateToHorizontal(tree)
        }
    }
    
    func canRotateToVertical(_ tree: Tree) -> Bool {
        if tree.center.row == 0 || tree.center.row == mapSize - 1 {
            return false
        }
        
        let targets: [Coordinate] = [
            Coordinate(row: tree.center.row - 1, col: tree.center.col - 1),
            Coordinate(row: tree.center.row - 1, col: tree.center.col),
            Coordinate(row: tree.center.row - 1, col: tree.center.col + 1),
            Coordinate(row: tree.center.row + 1, col: tree.center.col - 1),
            Coordinate(row: tree.center.row + 1, col: tree.center.col),
            Coordinate(row: tree.center.row + 1, col: tree.center.col + 1),
        ]
        
        for target in targets {
            if !target.isValidCoordinate(mapSize: mapSize) || map[target.row][target.col] == "1" {
                return false
            }
        }
        
        return true
    }
    
    func canRotateToHorizontal(_ tree: Tree) -> Bool {
        if tree.center.col == 0 || tree.center.col == mapSize - 1 {
            return false
        }
        let targets: [Coordinate] = [
            Coordinate(row: tree.center.row - 1, col: tree.center.col - 1),
            Coordinate(row: tree.center.row, col: tree.center.col - 1),
            Coordinate(row: tree.center.row + 1, col: tree.center.col - 1),
            
            Coordinate(row: tree.center.row - 1, col: tree.center.col + 1),
            Coordinate(row: tree.center.row, col: tree.center.col - 1),
            Coordinate(row: tree.center.row + 1, col: tree.center.col + 1),
        ]
        
        for target in targets {
            if !target.isValidCoordinate(mapSize: mapSize) || map[target.row][target.col] == "1" {
                return false
            }
        }
        
        return true
    }
    
    
    func isTreeRechedEnd(tree: Tree) -> Bool {
        for coordinate in tree.coordinates {
            if !coordinate.isValidCoordinate(mapSize: mapSize) || map[coordinate.row][coordinate.col] != "E" {
                return false
            }
        }
        
        return true
    }
    
    func findInitialTreeState() -> Tree {
        var isFirstTree = false
        
        let center = Coordinate(row: 0, col: 0)
        var tree = Tree(rotateDirection: 1, center: center)
        
        for i in 0..<mapSize {
            
            var isCenterFinded = false
            
            for j in 0..<mapSize {
                if map[i][j] == "B" {
                    if !isFirstTree {
                        isFirstTree = true
                    } else {
                        tree.center.row = i
                        tree.center.col = j
                        isCenterFinded = true
                    }
                }
            }
            
            if isCenterFinded {
                break
            }
        }
        
        if tree.center.col - 1 >= 0 && map[tree.center.row][tree.center.col - 1] == "B" {
            tree.rotateDirection = 0
        }
        
        return tree
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

    
    struct Tree {
        
        /// 0이면 가로, 1이면 세로
        var rotateDirection: Int
        var center: Coordinate
        
        var coordinates: [Coordinate] {
            if rotateDirection == 0 {
                return [
                    Coordinate(row: center.row, col: center.col - 1),
                    center,
                    Coordinate(row: center.row, col: center.col + 1),
                ]
            } else {
                return [
                    Coordinate(row: center.row - 1, col: center.col),
                    center,
                    Coordinate(row: center.row + 1, col: center.col),
                ]
            }
        }
        
        mutating func rotate() {
            if rotateDirection == 1 {
                rotateDirection = 0
            } else {
                rotateDirection = 1
            }
        }
        
        func findValidNextCoordinates(mapSize: Int) -> [Tree] {
            var withCurrentRotate = center.findNextValidCoordinates(mapSize: mapSize)
            
            if rotateDirection == 0 { // 가로인 경우
                withCurrentRotate = withCurrentRotate.filter { $0.col > 0 && $0.col < mapSize - 1 }
            } else {
                withCurrentRotate = withCurrentRotate.filter { $0.row > 0 && $0.row < mapSize - 1 }
            }
            
            
            let result =  withCurrentRotate.map { Tree(rotateDirection: rotateDirection, center: $0) }
            return result
        }
    }
    
    struct Coordinate {
        var row: Int
        var col: Int
        
        func isValidCoordinate(mapSize: Int) -> Bool {
            self.row >= 0 && self.row < mapSize && self.col >= 0 && self.col < mapSize
        }
        
        func findNextValidCoordinates(mapSize: Int) -> [Coordinate] {
            let candiates: [Coordinate] = [
                Coordinate(row: self.row + 1, col: self.col),
                Coordinate(row: self.row - 1, col: self.col),
                Coordinate(row: self.row, col: self.col - 1),
                Coordinate(row: self.row, col: self.col + 1),
            ]
            
            return candiates.filter { $0.isValidCoordinate(mapSize: mapSize) }
        }
    }
}
    
