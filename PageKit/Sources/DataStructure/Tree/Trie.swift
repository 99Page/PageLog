//
//  Trie.swift
//  PageKit
//
//  Created by 노우영 on 9/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

final class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEnd = false
}

final class Trie {
    private let root = TrieNode()

    func insert(_ word: String) {
        var node = root
        for ch in word {
            node = node.children[ch, default: TrieNode()]
        }
        node.isEnd = true
    }

    func autocomplete(prefix: String, limit: Int = 20) -> [String] {
        guard limit > 0 else { return [] }
        
        // 접두사 노드까지 이동
        var node = root
        for ch in prefix {
            guard let next = node.children[ch] else { return [] }
            node = next
        }
        
        var result: [String] = []
        var path: [Character] = []
        
        dfs(node, prefix: prefix, path: &path, result: &result, limit: limit)
        return result
    }

    private func dfs(_ cur: TrieNode, prefix: String, path: inout [Character], result: inout [String], limit: Int) {
        if result.count >= limit { return }
        if cur.isEnd { result.append(prefix + String(path)) }
        for (ch, child) in cur.children {
            path.append(ch)
            dfs(child, prefix: prefix, path: &path, result: &result, limit: limit)
            path.removeLast()
            if result.count >= limit { return }
        }
    }

    @discardableResult
    func contains(_ word: String) -> Bool {
        var node = root
        for ch in word {
            guard let next = node.children[ch] else { return false }
            node = next
        }
        return node.isEnd
    }

    /// Deletes a word if present. Returns true if a deletion occurred.
    @discardableResult
    func remove(_ word: String) -> Bool {
        // Stack for backtracking: (parent, char)
        var stack: [(node: TrieNode, ch: Character)] = []
        var node = root
        for ch in word {
            guard let next = node.children[ch] else { return false }
            stack.append((node, ch))
            node = next
        }
        guard node.isEnd else { return false }
        node.isEnd = false

        // Prune nodes that became useless (no children and not end-of-word)
        while let last = stack.popLast() {
            let parent = last.node
            let ch = last.ch
            if let child = parent.children[ch], child.children.isEmpty && !child.isEnd {
                parent.children.removeValue(forKey: ch)
            } else {
                break
            }
        }
        return true
    }
    
}
