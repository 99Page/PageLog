//
//  SwiftChartBasicView.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Charts
import SwiftUI

/// Swift chart의 기본 이용 방법
///
/// # Reference
/// [Creating a chart using Swift charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)
struct SwiftChartBasicView: View {
    
    var stackedBarData: [ToyShape] = [
        .init(color: "Green", type: "Cube", count: 2),
        .init(color: "Green", type: "Sphere", count: 0),
        .init(color: "Green", type: "Pyramid", count: 1),
        .init(color: "Purple", type: "Cube", count: 1),
        .init(color: "Purple", type: "Sphere", count: 1),
        .init(color: "Purple", type: "Pyramid", count: 1),
        .init(color: "Pink", type: "Cube", count: 1),
        .init(color: "Pink", type: "Sphere", count: 2),
        .init(color: "Pink", type: "Pyramid", count: 0),
        .init(color: "Yellow", type: "Cube", count: 1),
        .init(color: "Yellow", type: "Sphere", count: 1),
        .init(color: "Yellow", type: "Pyramid", count: 2)
    ]
    
    var body: some View {
        Chart {
            ForEach(stackedBarData) { shape in
                BarMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Total Count", shape.count)
                )
                // 차트 하단에 값을 구분해주는 역할을 한다.
                .foregroundStyle(by: .value("Shape Color", shape.color))
            }
        }
        // foregroundStyle에서 전달된 값을 받아 컬러로 매칭시켜주는 동작을 한다.
        .chartForegroundStyleScale([
            "Green": .green, "Purple": .purple, "Pink": .pink, "Yellow": .yellow
        ])
    }
}

#Preview {
    SwiftChartBasicView()
}
