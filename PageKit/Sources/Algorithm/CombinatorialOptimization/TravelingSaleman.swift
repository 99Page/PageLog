//
//  TravelingSaleman.swift
//  PageKit
//
//  Created by 노우영 on 5/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 외판원 문제(Traveling Salesman Problem, TSP)를 Bitmask + DP 방식으로 해결하는 구조체입니다.
///
/// ---
/// ⏱️ 시간 복잡도
///
/// - 전체 상태 수: 도시 수 N에 대해 (도시 위치) × (방문 상태) = N × 2^N
/// - 각 상태마다 재귀 호출 1회 → 총 시간 복잡도는 O(N × 2^N)
/// - 공간 복잡도도 memoization 배열에 따라 O(N × 2^N)
///
/// 이 구현은 도시 수가 20 이하일 때 현실적으로 사용 가능하며,
/// 그 이상은 메모리 사용량과 시간 초과 문제가 발생할 수 있습니다.
/// ---
struct TravelingSalesman {
    
    /// 도시의 개수
    let cityCount: Int
    
    /// 각 도시 간 이동 비용 (travelCost[i][j]는 i에서 j로 가는 비용)
    let travelCost: [[Int]]
    
    /// 메모이제이션 배열
    /// memoization[currentCity][visitedMask]는
    /// 현재 currentCity에 위치하며 visitedMask로 나타낸 도시들을 방문한 상태일 때
    /// 남은 도시를 모두 방문하고 시작점으로 돌아오는 최소 비용을 저장합니다.
    var memoization: [[Int]]
    
    /// 연결이 없는 경우 사용할 충분히 큰 숫자
    let INF = Int.max / 2

    /// 생성자: 도시 수와 이동 비용 행렬을 초기화합니다.
    init(cityCount: Int, travelCost: [[Int]]) {
        self.cityCount = cityCount
        self.travelCost = travelCost
        self.memoization = Array(
            repeating: Array(repeating: -1, count: 1 << cityCount),
            count: cityCount
        )
    }

    /// 외판원 문제의 최소 비용을 계산합니다.
    /// 시작 도시는 0번 도시로 고정되어 있습니다.
    /// - Parameter returnToStart: true면 시작점으로 돌아오는 경로, false면 그냥 끝나는 경로
    mutating func findMinimumTourCost(returnToStart: Bool = true) -> Int {
        return computeMinCost(currentCity: 0, visitedMask: 1 << 0, returnToStart: returnToStart)
    }

    /// 현재 도시와 방문한 도시 집합을 기준으로 최소 경로 비용을 재귀적으로 계산합니다.
    ///
    /// - Parameters:
    ///   - currentCity: 현재 위치한 도시
    ///   - visitedMask: 방문한 도시를 나타내는 비트마스크
    ///   - returnToStart: 시작점으로 돌아오는 경로인지 여부
    /// - Returns: 해당 상태에서의 최소 경로 비용
    private mutating func computeMinCost(currentCity: Int, visitedMask: Int, returnToStart: Bool) -> Int {
        // 모든 도시를 방문한 경우 → 시작 도시로 복귀 비용 반환 또는 종료
        if visitedMask == (1 << cityCount) - 1 {
            if returnToStart {
                return travelCost[currentCity][0] != 0 ? travelCost[currentCity][0] : INF
            } else {
                return 0
            }
        }

        // 이미 계산된 경우 메모값 사용
        if memoization[currentCity][visitedMask] != -1 {
            return memoization[currentCity][visitedMask]
        }

        var minCost = INF

        // 다음 도시 후보 순회
        for nextCity in 0..<cityCount {
            let alreadyVisited = visitedMask & (1 << nextCity) != 0
            let hasRoute = travelCost[currentCity][nextCity] != 0

            if alreadyVisited || !hasRoute { continue }

            // 다음 도시 방문 상태 업데이트
            let updatedMask = visitedMask | (1 << nextCity)

            // 다음 도시로 이동한 후의 비용 + 현재 도시에서 다음 도시로 가는 비용
            let candidateCost = computeMinCost(currentCity: nextCity, visitedMask: updatedMask, returnToStart: returnToStart) + travelCost[currentCity][nextCity]

            // 최소 비용 갱신
            minCost = min(minCost, candidateCost)
        }

        // 메모이제이션 저장 후 반환
        memoization[currentCity][visitedMask] = minCost
        return minCost
    }
}
