////
////  main.swift
////  2024.APC
////
////  Created by 노우영 on 8/29/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
///// Greedy하게 가자
///// daldidan은 예외 처리 필요할거 같다.
///// 최대 2번, 최소 1번
/////
///// 나머지 daldidalgo는 이분탐색으로 할 수 있다
/////
///// 짝수개일 때는
///// 1번으로 가능
/////
/////
///// ex) 8개일 때는
///// 4개 입력 + 1회
/////
///// dal di da n
///// dal di dalgo
//
//// daldi = 5
//// dal = 1
//// go = 2
//let intialDaldidalgoSec = 10
//let daldidalgoCount = Int(readLine()!)!
//solve()
//
///// daldidalgo daldidan
///// 8                       9 10
///// daldidalgo daldidalgo daldida n (n=2)
///// 8                     9              10      11
/////
///// daldidalgo daldidalgo daldidalgo daldida n
///// 8                     9                         10           11
///// daldidalgo daldidalgo daldidalgo daldidalgo daldidan (n=4)
///// 8                     9                          10                        11 12
/////
///// daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidan (n=5)
/////      8       9                                      10                       11         12
///// daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidan (n=6)
/////      8       9                                     10                                             11      12
///// daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidan (n=7)
/////      8       9                                     10                                                                   11  12
///// daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidalgo daldidan (n=8)
/////      8       9                                     10                                                                   11             12 13
//
///// 1 -> 2 -> 4 -> 8로 갈때마다 1씩 증가
//
//
//func solve() {
//    var result: Int = 0
//    
//    result += calculateDaldidalgoTypingSec(1, value: intialDaldidalgoSec)
//    
//    print(result)
//}
//
//func calculateDaldidalgoTypingSec(_ count: Int, value: Int) -> Int {
//    let next = count * 2
//    
//    if next <= daldidalgoCount {
//        return calculateDaldidalgoTypingSec(next, value: value + 1)
//    } else {
//        return value
//    }
//}
