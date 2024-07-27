//
//  16928번-뱀과 사다리 게임.swift
//  no16928
//
//  Created by 노우영 on 7/27/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// key: 도착한 칸
/// value: 이동할 칸
var jumps: [Int: Int] = [:]

/// index: 게임판의 위치
/// value: 도착을 위한 최소 회수
/// 0번 인덱스는 무시합니다.
var board: [Int] = Array(repeating: 101, count: 101)

let (n, m) = readChairAndSnakeNumbers()

//fillJumps()
//move(nextPosition: 1, newMoveCountToCurrentPosition: 0)
//print(board[100])

/// move 함수는 현재 위치에서 주어진 이동 수를 기반으로 게임 보드에서 이동을 처리합니다.
/// - Parameters:
///   - currentPosition: 현재 위치를 나타내는 정수
///   - newMoveCountToCurrentPosition: 현재 위치까지의 새로운 이동 횟수
func move(nextPosition currentPosition: Int, newMoveCountToCurrentPosition: Int) {
    guard currentPosition < 101 else { return }
    
    let oldMinMoveToCurrentPosition = board[currentPosition]
    
    guard newMoveCountToCurrentPosition < oldMinMoveToCurrentPosition else { return }
    
    board[currentPosition] = newMoveCountToCurrentPosition
    
    if let jumpDestination = jumps[currentPosition] {
        move(nextPosition: jumpDestination, newMoveCountToCurrentPosition: newMoveCountToCurrentPosition)
    } else {
        for dieNumber in 1...6 {
            let nextPosition = currentPosition + dieNumber
            let newMinMoveToCurrentPosition = newMoveCountToCurrentPosition + 1
            move(nextPosition: nextPosition, newMoveCountToCurrentPosition: newMinMoveToCurrentPosition)
        }
    }
}

/// 주사위 게임에서 뱀과 사다리의 정보를 읽어와 jumps 딕셔너리에 저장합니다.
/// - Note: n은 사다리의 수, m은 뱀의 수를 나타냅니다.
func fillJumps() {
    for _ in 0..<n+m {
        let (source, destination) = readJump()
        jumps[source] = destination
    }
    
}

/// 주어진 입력으로부터 사다리나 뱀의 시작과 끝 위치를 읽어 반환합니다.
/// - Returns: 시작 위치와 끝 위치가 튜플 형태로 반환합니다.
func readJump() -> (Int, Int) {
    let input = readLine()
    let numbers = input?.split(separator: " ").compactMap { Int($0) }
    
    return (numbers![0], numbers![1])
}


/// 사다리와 뱀의 수를 입력받아 반환합니다.
/// - Returns: 사다리의 수와 뱀의 수를 튜플 형태로 반환합니다.
func readChairAndSnakeNumbers() -> (Int, Int) {
    let input = readLine()
    let numbers = input?.split(separator: " ").compactMap { Int($0) }
    
    return (numbers![0], numbers![1])
}
