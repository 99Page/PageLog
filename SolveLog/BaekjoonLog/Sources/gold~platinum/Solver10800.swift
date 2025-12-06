/// 방법
/// 전체를 정렬한다. n log n
/// 순회하고 구간의 합을 만든다 n
/// 각 컬러별로 별도의 배열을 만든다 n
/// 순회하면서 이분 탐색하고, 자신의 컬러 값은 뺀다 n log n
///

// # Test cases
//
//4
//1 1
//2 1
//3 1
//4 1

//4
//4 4
//2 2
//1 3
//3 1

struct Solver10800 {
    
    let maxColorValue = 2_000_000
    let peopleCount: Int
    var pickedColorball: [Colorball]
    
    var sortedColorballs: [Colorball]
    
    // colorball의 특정 인덱스까지 size를 합한 값
    var sumOfSize: [Int]
    
    /// 색상 별로 구분된 컬러볼 배열
    var splitedColorballs: [[Colorball]]
    /// 색상 별로 구분된 컬러볼 배열의 특정 인덱스까지 size를 합한 값
    var splitedSumOfSize: [[Int]]
    
    init() {
        self.peopleCount = Int(readLine()!)!
        self.sortedColorballs = []
        self.sumOfSize = []
        self.pickedColorball = []
        self.splitedColorballs = Array(repeating: [], count: maxColorValue + 1)
        self.splitedSumOfSize = Array(repeating: [], count: maxColorValue + 1)
        
        // 입력을 받아 컬러볼 배열 초기화
        (0..<peopleCount).forEach { _ in
            let colorballInput = readArray() as [Int]
            let colorball = Colorball(color: colorballInput[0], size: colorballInput[1])
            sortedColorballs.append(colorball)
            pickedColorball.append(colorball)
        }
        
        // 크기 순으로 정렬
        sortedColorballs.sort { $0.size < $1.size }
        
        // 정렬된 컬러볼로 누적 합 초기화
        initializeSumArrays()
    }
    
    /// 누적 합을 초기화합니다.
    private mutating func initializeSumArrays() {
        for (index, colorball) in sortedColorballs.enumerated() {
            updateTotalSum(index: index, size: colorball.size)
            updateColorSum(color: colorball.color, size: colorball.size)
            
            splitedColorballs[colorball.color].append(colorball)
        }
    }
    
    /// 전체 컬러볼의 누적 합을 업데이트합니다.
    /// - Parameters:
    ///   - index: 현재 컬러볼의 인덱스
    ///   - size: 현재 컬러볼의 크기
    private mutating func updateTotalSum(index: Int, size: Int) {
        let newSum = (index == 0 ? 0 : sumOfSize[index - 1]) + size
        sumOfSize.append(newSum)
    }
    
    /// 특정 색상의 누적 합을 업데이트합니다.
    /// - Parameters:
    ///   - color: 현재 컬러볼의 색상
    ///   - size: 현재 컬러볼의 크기
    private mutating func updateColorSum(color: Int, size: Int) {
        let previousSum = splitedSumOfSize[color].last ?? 0
        splitedSumOfSize[color].append(previousSum + size)
    }
    
    mutating func solve() {
        var result: [Int] = []
        
        for colorball in pickedColorball {
            let sum = calculateSumExcludingColorball(colorball, in: sortedColorballs, using: sumOfSize)
            let sumSplit = calculateSumExcludingColorball(colorball, in: splitedColorballs[colorball.color], using: splitedSumOfSize[colorball.color])
            
            result.append(sum - sumSplit)
        }
        
        print(result.joinedString(with: "\n"))
    }
    
    /// 특정 컬러볼을 제외한 구간의 합을 계산합니다.
    /// - Parameters:
    ///   - colorball: 계산할 기준이 되는 컬러볼
    ///   - colorballArray: 컬러볼이 정렬된 전체 배열 또는 색상별 배열
    ///   - sumArray: 구간합 배열
    /// - Returns: 특정 컬러볼을 제외한 구간의 합
    private func calculateSumExcludingColorball(_ colorball: Colorball, in colorballArray: [Colorball]?, using sumArray: [Int]?) -> Int {
        guard let colorballArray = colorballArray, let sumArray = sumArray else { return 0 }
        
        let lowerBoundIndex = colorballArray.findLowerBound(colorball)
        return lowerBoundIndex == 0 ? 0 : sumArray[lowerBoundIndex - 1]
    }
    
    
    
    struct Colorball: Comparable {
        static func < (lhs: Solver10800.Colorball, rhs: Solver10800.Colorball) -> Bool {
            lhs.size < rhs.size
        }
        
        let color: Int
        let size: Int
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

private extension Array where Element: Comparable {
    func findLowerBound(_ value: Element) -> Int {
        var low = 0
        var high = self.count
        
        while low < high {
            let mid = (low + high) / 2
            if self[mid] < value {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}


