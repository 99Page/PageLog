//
//  ExpandableCollectionViewController + collection.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 4/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension ExpandableCollectionViewController {
    var numberOfRows: Int {
        var result = 0
        let sections = collectionView.numberOfSections
        for section in 0..<sections {
            result += collectionView.numberOfItems(inSection: section)
        }
        return result / collectionState.maxColumnCount
    }
    
    func numberOfRows(in column: Int) -> Int {
        let itemCount = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        var result = 0
        var item = 0
        
        while item < itemCount {
            item += column
            result += 1
        }
        
        return result
    }
    
    /// 기존 컬럼 수(oldColumnCount)와 새로운 컬럼 수(newColumnCount)에 따른 row 개수 차이를 반환
    ///
    /// - Parameters:
    ///   - oldColumnCount: 기존 컬럼 수
    ///   - newColumnCount: 변경된 컬럼 수
    /// - Returns: 새로운 row 개수 - 기존 row 개수 (증감 차이)
    func rowDiff(oldColumnCount: Int, newColumnCount: Int) -> Int {
        let newRowCount = numberOfRows(in: newColumnCount)
        let oldRowCount = numberOfRows(in: oldColumnCount)
        
        return newRowCount - oldRowCount
    }
    
    func cellWidth(numberOfColumns: Int) -> CGFloat {
        guard let cachedWidth = collectionState.cachedWidth else { return 0 }
        let width = cachedWidth / CGFloat(numberOfColumns)
        return width
    }
}
