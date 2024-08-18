//
//  MinHeapTest.swift
//  HeapTests
//
//  Created by 노우영 on 8/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
@testable import Heap

final class MinHeapTest: XCTestCase {

    var minHeap: Heap<Int>!
    
    override func setUpWithError() throws {
        minHeap = Heap<Int>.minHeap()
    }
    
    func getRandomElement() -> Int {
        Int.random(in: -999..<1000)
    }
}
