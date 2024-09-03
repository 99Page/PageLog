////
////  main.swift
////  bronze.to.silver.solve
////
////  Created by 노우영 on 9/3/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//let coordinateCount = Int(readLine()!)!
//let coordinates: [Int] = readArray()
//let maxCoordinate = 1_000_000
//
//solve()
//
//func solve() {
//    let dict: [Int: Int] = createDitionary()
//    var compressedCoordinates: [Int] = []
//    
//    for coordinate in coordinates {
//        let compressedCoordinate = dict[coordinate]!
//        compressedCoordinates.append(compressedCoordinate)
//    }
//    
//    let result = compressedCoordinates.joinedString()
//    print(result)
//}
//
//func createDitionary() -> [Int: Int] {
//    let sortedCoordinates = coordinates.sorted()
//    var lastCoordinate = maxCoordinate + 1
//    var lastCompressedCoordinate = -1
//    var result: [Int: Int] = [:]
//    
//    for coordinate in sortedCoordinates {
//        if lastCoordinate == coordinate {
//            continue
//        } else {
//            let currentCompressedCoordinate = lastCompressedCoordinate + 1
//            result[coordinate] = lastCompressedCoordinate + 1
//            lastCoordinate = coordinate
//            lastCompressedCoordinate = currentCompressedCoordinate
//        }
//    }
//    
//    return result
//}
//
//extension Array where Element: LosslessStringConvertible {
//    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
//    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
//    /// - Returns: 결합된 문자열
//    func joinedString(with separator: String = " ") -> String {
//        self.map(String.init).joined(separator: separator)
//    }
//}
//
//
//func readArray<T: LosslessStringConvertible>() -> [T] {
//    let line = readLine()!
//    let splitedLine = line.split(separator: " ")
//    let array = splitedLine.map { T(String($0))! }
//    return array
//}
//
