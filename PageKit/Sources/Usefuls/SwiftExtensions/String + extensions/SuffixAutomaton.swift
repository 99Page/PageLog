//
//  SuffixAutomaton.swift
//  PageKit
//
//  Created by 노우영 on 9/25/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 문자열의 모든 부분 문자열을 구하는 알고리즘. O(n)
///
/// [자세한 알고리즘](https://cp-algorithms.com/string/suffix-automaton.html#algorithm)
///
/// ## Suffix Automaton
///
/// Suffix Automaton은 결정적 유한 상태 기계(Deterministic Finite Automata)라고 부른다. 어떤 상태들이 있을 때 다른 상태로 변경되는 경로(transition)가 유일하다는 뜻이다.
///
/// 그래프로 봤을 때 State = Node, Transition = Edge를 뜻한다.
///
/// ## 상태
///  해당 문자열이 나타나는 마지막 모든 위치를 구하는 함수를 `endPos` 라고 하자. 이게 동일하면 모두 동일한 상태가 된다.
///
///  문자열 abb의 상황에서는 이렇다.
///  * endPos(a) = { 0 }
///  * endPos(b) = { 1, 2 }
///  * endPos(ab) = { 1 }
///  * endPos(bb) = { 2 }
///  * endPos(abb) = { 2 }
///
/// ## 링크
///
/// SAM에서 상태가 무엇을 뜻하는지 살펴봤다. 그러면 transition을 만들어야하는데 SAM에서는 transition을 만들기 위해 링크를 먼저 만들어줘야한다.
///
/// 링크를 이해하기 위해 문자열 abcbc 상황에서 상태를 만들어보자. ( ) 안은 상태의 번호다,.
///
/// * endPos(a) = { 0 }  >  (1)
/// * endPos(b) = {1, 3 } > (2)
/// * endPos(c) = { 2, 4 } > (3)
/// * endPos(ab) = { 1 } > (4)
/// * endPos(bc) = { 2, 4 } > (3)
/// * endPos(cb) = { 3 } > (5)
/// * endPos(abc) = { 2 } > (6)
/// * endPos(bcb) = { 3 } > (5)
/// * endPos(cbc) = { 4 } > (7)
/// * endPos(abcb) = { 3 } > (5)
/// * endPos(bcbc) = { 4 } > (4)
/// * endPos(abcbc) = { 4 } > (4)
///
/// 총 7개의 상태가 만들어진다. 각 문자열 상황에서 앞의 단어를 하나씩 지웠을 때 endPos 값이 달라지는 상황이 올 것이다. 그 때 생기는 상태 값으로 링크를 이어주면 된다.
///
/// abcbc에서 한개씩 줄여보자. endPos(abcbc) = (4). endPos(bcbc) = (4). endPos(cbc) = (4). endPos(bc) = (3). 즉 4번 상태는 3번 상태로 link를 만들어주면 된다.
///
/// ## Transition
///
/// 이제 만들어준 링크로 Transition을 생성해준다. 시간 관계상 일단 생략하고, 다음에 작성!
///
struct SuffixAutomaton {
     /// 내부 상태(State)
     /// - length: 이 상태가 표현할 수 있는 부분문자열의 최대 길이
     /// - link: suffix link (실패 링크)
     /// - next: 문자 전이
     struct State {
         var length: Int
         var link: Int
         var next: [Character: Int]
     }

     private(set) var states: [State] = [State(length: 0, link: -1, next: [:])]
     private var last: Int = 0

     /// 함수: 문자를 하나 확장하여 자동자를 증가 구성합니다.
     /// - 매개변수 c: 추가할 문자
     mutating func extend(with c: Character) {
         let cur = states.count
         states.append(State(length: states[last].length + 1, link: 0, next: [:]))

         var p = last
         while p != -1 && states[p].next[c] == nil {
             states[p].next[c] = cur
             p = states[p].link
         }

         if p == -1 {
             states[cur].link = 0
         } else {
             let q = states[p].next[c]!
             if states[p].length + 1 == states[q].length {
                 states[cur].link = q
             } else {
                 // clone 상태 생성 (전이를 복제하여 길이만 조정)
                 let clone = states.count
                 states.append(State(length: states[p].length + 1,
                                     link: states[q].link,
                                     next: states[q].next))
                 var pp = p
                 while pp != -1 && states[pp].next[c] == q {
                     states[pp].next[c] = clone
                     pp = states[pp].link
                 }
                 states[q].link = clone
                 states[cur].link = clone
             }
         }
         last = cur
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
