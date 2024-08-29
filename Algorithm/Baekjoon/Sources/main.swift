//
//  main6.swift
//  2024.APC
//
//  Created by 노우영 on 8/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

// - Conditions
// [] 연산의 회수: 0 <= cal <= N/2
// [] 내림 차순
// 연산? 특정 값을 골라서 특정 원소에는 더하고 특정 원소에는 빼기

// 내가 해야할 것..
// 연산을 할 두가지 인덱스를 찾고
// 얼마를 주고 받을지 결정.
//
// 앞의 인덱스는 고정시킨다.
// 앞의 인덱스는 스왑 후 이동시킨다.
// 뒤의 인덱스는 내림차순이 아닌 걸 만날때까지 계속 이동시킨다.
// 뒤의 인덱스에서 앞으로 줄 수 있는 가장 큰 값을 준다.


let arraySize = Int(readLine()!)!

