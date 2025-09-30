var solver = Solver11478()
solver.solve()

struct Solver11478 {
    
    var subsetOfString = Set<[Character]>()
    
    mutating func solve() {
        let input: [Character] = [Character](readLine()!)
        var sam = SuffixAutomaton()
        
        for character in input {
            sam.extend(with: character)
        }
        
        print(sam.countDistinctSubstrings())
        
        for (index, value) in sam.states.enumerated() {
            print("\(index): \(value)")
        }
    }
    
    struct SuffixAutomaton {
        /// 내부 상태(State)
        /// - length: 이 상태가 표현할 수 있는 부분문자열의 최대 길이
        /// - link: suffix link (실패 링크)
        /// - next: 문자 전이
        struct State {
            var length: Int
            
            /// endPos가 최초로 달라지는 상태의 ID 값
            var link: Int
            var next: [Character: Int]
        }

        private(set) var states: [State] = [State(length: 0, link: -1, next: [:])]
        private var lastStateID: Int = 0

        /// 함수: 문자를 하나 확장하여 자동자를 증가 구성합니다.
        /// - 매개변수 c: 추가할 문자
        mutating func extend(with c: Character) {
            let cur = states.count
            states.append(State(length: states[lastStateID].length + 1, link: 0, next: [:]))

            var pointor = lastStateID
            
            while pointor != -1 && states[pointor].next[c] == nil {
                states[pointor].next[c] = cur
                pointor = states[pointor].link
            }

            if pointor == -1 {
                states[cur].link = 0
            } else {
                let q = states[pointor].next[c]!
                
                if shouldSplitState(pointor: pointor, character: c) {
                    states[cur].link = q
                } else {
                    // clone 상태 생성 (전이를 복제하여 길이만 조정)
                    let clone = states.count
                    states.append(State(length: states[pointor].length + 1,
                                        link: states[q].link,
                                        next: states[q].next))
                    var pp = pointor
                    while pp != -1 && states[pp].next[c] == q {
                        states[pp].next[c] = clone
                        pp = states[pp].link
                    }
                    states[q].link = clone
                    states[cur].link = clone
                }
                
            }
            lastStateID = cur
        }
        
        func shouldSplitState(pointor: Int, character: Character) -> Bool {
            let q = states[pointor].next[character]!
            return states[pointor].length + 1 == states[q].length
        }

        /// 함수: 서로 다른 부분문자열의 개수를 계산합니다.
        /// - 반환값: 부분문자열의 개수 (중복 제외)
        /// - 설명: Σ (len[v] - len[link[v]]), v ≠ root
        func countDistinctSubstrings() -> Int {
            var total = 0
            for v in 1..<states.count {
                total += states[v].length - states[states[v].link].length
            }
            return total
        }
    }

}

