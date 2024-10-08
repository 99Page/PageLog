private struct Solver1365 {
    
    let lineCount: Int
    let powerLines: [Int]
    
    init() {
        self.lineCount = Int(readLine()!)!
        self.powerLines = readArray()
    }
    
    /// 백준 1365번 문제를 해결하기 위한 함수
    ///
    /// # 문제 접근
    /// 문제 유형 상 배열을 앞에서 하나씩 조회하는 수밖에 없다. 그리고 이런 step by step의 배열 조회에 어울리는 방식은 Dynamic programming이다.
    ///
    /// DP를 사용하는 경우를 다시 정리해보면 크게 두가지다.
    /// 1. 반복 조회를 줄이고 싶을 때(탐색 시 재방문을 줄이고 싶을 때)
    /// 2. 주어진 배열을 순차적으로 조회하며 다른 의미있는 배열을 만들고 싶을 때.
    ///
    /// 이 문제는 2번의 유형이고,
    /// 전봇대의 크기 순서대로 정렬이 가능하니 이분탐색 활용이 가능하다.
    ///
    /// 단순하게, LIS 알고리즘을 안다면 그걸 바로 적용해도 된다.
    func solve() {
        var orderedPowerLines: [Int] = []
        
        for powerLine in powerLines {
            let lowerBound = orderedPowerLines.findLowerBound(powerLine)
            
            if lowerBound < orderedPowerLines.count {
                orderedPowerLines[lowerBound] = powerLine
            } else {
                orderedPowerLines.append(powerLine)
            }
        }
        
        let result = powerLines.count - orderedPowerLines.count
        print(result)
    }
}



private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}



private extension Array where Element: Comparable {
    /// 이진 탐색을 사용하여 배열에서 주어진 값보다 크거나 같은 첫 번째 위치를 반환합니다.
    ///
    /// 배열은 미리 정렬되어 있어야 합니다.
    /// - Parameter value: 탐색할 값
    /// - Returns: 주어진 값보다 크거나 같은 첫 번째 요소의 인덱스, 없으면 배열의 크기
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

