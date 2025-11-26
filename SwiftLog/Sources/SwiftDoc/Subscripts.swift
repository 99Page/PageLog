//
//  Subscripts.swift
//  SwiftDocument
//
//  Created by 노우영 on 11/6/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// # Subscript 정의
/// Class, Struct, Enum 등에 정의된 데이터에 접근하는 숏컷.
///

// MARK: Subscript syntax

struct TimesTable {
    let multiplier: Int
    
    subscript (index: Int) -> Int {
        multiplier * index
    }
}

// MARK: Subscript Usage


/// 아래 타입은 이런 식으로 사용할 수 있다.
/// ```
/// var myDrinks = MyDrinks()
/// myDrinks[.coffee] = 3
/// print(myDrinks[.coffee])
/// ```

struct MyDrinks {
    var waterCount = 0
    var coffeeCount = 0
    var cokeCount = 0
    
    subscript (drink: Drink) -> Int {
        get {
            switch drink {
            case .water: waterCount
            case .coffee: coffeeCount
            case .coke: cokeCount
            }
        }
        
        set {
            switch drink {
            case .water: waterCount = newValue
            case .coffee: coffeeCount = newValue
            case .coke: cokeCount = newValue
            }
        }
    }
    
    enum Drink {
        case water
        case coffee
        case coke
    }
}


// MARK: Subscript Options

/// Subscript의 parameter 개수나 타입은 상관없다.
/// 함수가 갖는 문법과 유사한데, inout은 안된다.

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    /// 이런 식으로, 여러개 parameter 갖는게 가능하다.
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

// MARK: Type Scripts

/// 아래처럼 타입 스크립트도 사용할 수 있다. 
struct JustNumbers {
    static var one = 1
    static var two = 2
    static var three = 3
    
    static subscript(_ index: Int) -> Int? {
        get {
            switch index {
            case 1: return one
            case 2: return two
            case 3: return three
            default: return nil
            }
        }
    }
}
