//
//  AVLTree.swift
//  PageCollection
//
//  Created by 노우영 on 11/5/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// AVL Tree Node 구조체
class AVLTreeNode<T: Comparable> {
    var value: T
    var left: AVLTreeNode?
    var right: AVLTreeNode?
    var height: Int

    init(value: T, height: Int = 1) {
        self.value = value
        self.height = height
    }
}

/// AVL Tree 클래스
///
/// 삽입/삭제 시 높이가 log N을 넘지 않도록 회전
/// 탐색 속도를 최적화하는 트리
class AVLTree<T: Comparable> {
    private var root: AVLTreeNode<T>?

    /// 노드의 높이를 반환하는 함수
    private func height(_ node: AVLTreeNode<T>?) -> Int {
        return node?.height ?? 0
    }

    /// 노드의 균형 인수를 반환하는 함수
    private func getBalance(_ node: AVLTreeNode<T>?) -> Int {
        return (node == nil) ? 0 : height(node?.left) - height(node?.right)
    }

    /// 노드를 오른쪽으로 회전하는 함수
    private func rotateRight(_ y: AVLTreeNode<T>) -> AVLTreeNode<T> {
        let x = y.left!
        let T2 = x.right

        // 회전 수행
        x.right = y
        y.left = T2

        // 높이 업데이트
        y.height = max(height(y.left), height(y.right)) + 1
        x.height = max(height(x.left), height(x.right)) + 1

        return x
    }

    /// 노드를 왼쪽으로 회전하는 함수
    private func rotateLeft(_ x: AVLTreeNode<T>) -> AVLTreeNode<T> {
        let y = x.right!
        let T2 = y.left

        // 회전 수행
        y.left = x
        x.right = T2

        // 높이 업데이트
        x.height = max(height(x.left), height(x.right)) + 1
        y.height = max(height(y.left), height(y.right)) + 1

        return y
    }

    /// 노드를 삽입하는 함수
    func insert(value: T) {
        root = insert(root, value)
    }

    private func insert(_ node: AVLTreeNode<T>?, _ value: T) -> AVLTreeNode<T> {
        guard let node = node else {
            return AVLTreeNode(value: value)
        }

        if value < node.value {
            node.left = insert(node.left, value)
        } else if value > node.value {
            node.right = insert(node.right, value)
        } else {
            return node // 중복된 값은 삽입하지 않음
        }

        // 높이 업데이트
        node.height = 1 + max(height(node.left), height(node.right))

        // 균형 인수 계산
        let balance = getBalance(node)

        // LL 회전
        if balance > 1 && value < node.left!.value {
            return rotateRight(node)
        }

        // RR 회전
        if balance < -1 && value > node.right!.value {
            return rotateLeft(node)
        }

        // LR 회전
        if balance > 1 && value > node.left!.value {
            node.left = rotateLeft(node.left!)
            return rotateRight(node)
        }

        // RL 회전
        if balance < -1 && value < node.right!.value {
            node.right = rotateRight(node.right!)
            return rotateLeft(node)
        }

        return node
    }
}
