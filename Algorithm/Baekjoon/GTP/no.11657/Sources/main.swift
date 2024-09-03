//
//  main.swift
//  bronze.to.silver.solve
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let input: [Int] = readArray()
let cityCount = input[0]
let edgeCount = input[1]

var buses: [[Bus]] = Array(repeating: [], count: cityCount + 1)
var costs: [Int] = Array(repeating: .max, count: cityCount + 1)

readBuses()
solve()

func solve() {
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

func hasLoop() -> Bool {
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

func updateCost() {
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


func readBuses() {
    (0..<edgeCount).forEach { _ in
        let input: [Int] = readArray()
        let startCity = input[0]
        let destinationCity = input[1]
        let cost = input[2]
        let bus = Bus(destination: destinationCity, time: cost)
        
        buses[startCity].append(bus)
    }
}

struct Bus {
    let destination: Int
    let time: Int
    
    static let empty = Bus(destination: 0, time: 0)
}


extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}


func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

