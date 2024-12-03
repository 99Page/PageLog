var solver = Solver27495()
solver.solve()


struct Solver27495 {
    let goals: [[String]]
    
    let rowSize = 9
    let colSize = 9
    
    init() {
        var goals: [[String]] = []
        
        (0..<rowSize).forEach { _ in
            let goalRow = readLine()!.split(separator: " ").map { String($0) }
            goals.append(goalRow)
            print(goalRow)
        }
        
        self.goals = goals
    }
    
    mutating func solve() {
        let planRange = 0...8
        processGoal(rowRange: planRange, colRange: planRange, level: .final)
    }
    
    mutating func processGoal(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>, level: GoalLevel) {
        guard !level.isBottom else { return }
        
        let subGoalMatrixSize = 3
        let subgoalLength = rowRange.count / 3
        
        var subgoals: [Goal] = []
        
        let adding = subgoalLength / 3
        
        for row in 1...subGoalMatrixSize {
            let rowIndex = row * subgoalLength - subgoalLength + adding
            let subGoalRowRange = rowIndex-adding...rowIndex+adding
            
            for col in 1...subGoalMatrixSize {
                
                let colIndex = col * subgoalLength - subgoalLength + adding
                let subGoalColRange = colIndex-adding...colIndex+adding
                
                if !(row == 2 && col == 2) {
                    let subgoalName = goals[rowIndex][colIndex]
                    let subgoal = Goal(name: subgoalName, rowRange: subGoalRowRange, colRange: subGoalColRange)
                    subgoals.append(subgoal)
                }
            }
        }
        
        subgoals.sort()
        
        for (index, subgoal) in subgoals.enumerated() {
            let sublevel = level.findNextLevel(value: index + 1)
            print("\(sublevel.suffix) \(subgoal.name)")
            processGoal(rowRange: subgoal.rowRange, colRange: subgoal.colRange, level: sublevel)
        }
    }
    
    struct Goal: Comparable {
        static func < (lhs: Solver27495.Goal, rhs: Solver27495.Goal) -> Bool {
            lhs.name < rhs.name
        }
        
        let name: String
        let rowRange: ClosedRange<Int>
        let colRange: ClosedRange<Int>
    }
    
    enum GoalLevel {
        case final
        case middle(Int)
        case bottom(middle: Int, bottom: Int)
        
        var isBottom: Bool {
            guard case .bottom = self else {
                return false
            }
            
            return true
        }
        
        var suffix: String {
            switch self {
            case .final:
                ""
            case .middle(let int):
                "#\(int)."
            case .bottom(let middle, let bottom):
                "#\(middle)-\(bottom)."
            }
        }
        
        func findNextLevel(value: Int) -> GoalLevel {
            switch self {
            case .final:
                return .middle(value)
            case .middle(let middle):
                return .bottom(middle: middle, bottom: value)
            case .bottom(let middle, let bottom):
                return .bottom(middle: middle, bottom: bottom)
            }
        }
    }
}
