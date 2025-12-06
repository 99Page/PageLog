//
//  Solver11657.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation


struct Solver11657 {
    let cityCount: Int
    let edgeCount: Int

    var buses: [[Bus]]
    var costs: [Int]

    
    init() {
        let input: [Int] = Reader.readArray()
        self.cityCount = input[0]
        self.edgeCount = input[1]
        
        self.buses = Array(repeating: [], count: cityCount + 1)
        self.costs = Array(repeating: .max, count: cityCount + 1)
        
        readBuses()
    }
    
    private mutating func readBuses() {
        (0..<edgeCount).forEach { _ in
            let input: [Int] = Reader.readArray()
            let startCity = input[0]
            let destinationCity = input[1]
            let cost = input[2]
            let bus = Bus(destination: destinationCity, time: cost)
            
            buses[startCity].append(bus)
        }
    }
    
    
    mutating func solve() {
        costs[1] = 0
        
        (0..<cityCount - 1).forEach { _ in
            updateCost()
        }
        
        if hasLoop() {
            print("-1")
        } else {
            for index in (2..<costs.count) {
                if costs[index] == .max {
                    print("-1")
                } else {
                    print(costs[index])
                }
            }
        }
    }

    private func hasLoop() -> Bool {
        var result = false
        
        (1..<buses.count).forEach { index in
            let busArray = buses[index]
            
            for bus in busArray {
                if result {
                    break
                }
                
                if costs[index] != .max {
                    let destination = bus.destination
                    let newCost = costs[index] + bus.time
                    
                    if costs[destination] > newCost {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }

    private mutating func updateCost() {
        (1..<buses.count).forEach { index in
            let busArray = buses[index]
            
            for bus in busArray {
                if costs[index] != .max {
                    let destination = bus.destination
                    let newCost = costs[index] + bus.time
                    costs[destination] = min(costs[destination], newCost)
                }
            }
        }
    }

    
    struct Bus {
        let destination: Int
        let time: Int
        
        static let empty = Bus(destination: 0, time: 0)
    }

    
    
    struct Reader {
        static func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
            var result: [[T]] = []
                
            (0..<k).forEach { _ in
                let array: [T] = readArray()
                result.append(array)
            }
            
            return result
        }

        static func readArray<T: LosslessStringConvertible>() -> [T] {
            let line = readLine()!
            let splitedLine = line.split(separator: " ")
            let array = splitedLine.map { T(String($0))! }
            return array
        }

    }
}
