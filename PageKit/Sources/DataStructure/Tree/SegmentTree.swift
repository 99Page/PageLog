//
//  SegmentTree.swift
//  PageKit
//
//  Created by 노우영 on 5/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct SegmentTree {
    private var tree: [Int]
    private var size: Int

    init(array: [Int]) {
        size = array.count
        tree = Array(repeating: 0, count: size * 4)
        build(array, node: 1, start: 0, end: size - 1)
    }

    private mutating func build(_ array: [Int], node: Int, start: Int, end: Int) {
        if start == end {
            tree[node] = array[start]
        } else {
            let mid = (start + end) / 2
            build(array, node: node * 2, start: start, end: mid)
            build(array, node: node * 2 + 1, start: mid + 1, end: end)
            tree[node] = tree[node * 2] + tree[node * 2 + 1]
        }
    }

    /// 구간 [l...r]의 합을 반환
    func query(_ l: Int, _ r: Int) -> Int {
        return query(node: 1, start: 0, end: size - 1, l: l, r: r)
    }

    private func query(node: Int, start: Int, end: Int, l: Int, r: Int) -> Int {
        if r < start || end < l {
            return 0 // 겹치지 않음
        }
        if l <= start && end <= r {
            return tree[node] // 완전히 포함됨
        }
        let mid = (start + end) / 2
        let leftSum = query(node: node * 2, start: start, end: mid, l: l, r: r)
        let rightSum = query(node: node * 2 + 1, start: mid + 1, end: end, l: l, r: r)
        return leftSum + rightSum
    }

    /// 특정 인덱스의 값을 갱신
    mutating func update(index: Int, value: Int) {
        update(node: 1, start: 0, end: size - 1, idx: index, val: value)
    }

    private mutating func update(node: Int, start: Int, end: Int, idx: Int, val: Int) {
        if start == end {
            tree[node] = val
        } else {
            let mid = (start + end) / 2
            if idx <= mid {
                update(node: node * 2, start: start, end: mid, idx: idx, val: val)
            } else {
                update(node: node * 2 + 1, start: mid + 1, end: end, idx: idx, val: val)
            }
            tree[node] = tree[node * 2] + tree[node * 2 + 1]
        }
    }
}
