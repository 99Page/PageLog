//
//  LinePlotView.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Charts
import SwiftUI

struct LinePlotView: View {
    @State var type: LinePlotType = .functions
    
    /// Sample expense data for the chart.
    private var expenses: [Expense] = [
        Expense(month: 1, cost: 151, category: "hobby"),
        Expense(month: 2, cost: 131, category: "hobby"),
        Expense(month: 3, cost: 89, category: "hobby"),
        Expense(month: 4, cost: 160, category: "hobby"),
        Expense(month: 5, cost: 70, category: "hobby"),
        Expense(month: 6, cost: 124, category: "hobby"),
        Expense(month: 1, cost: 351, category: "food"),
        Expense(month: 2, cost: 321, category: "food"),
        Expense(month: 3, cost: 370, category: "food"),
        Expense(month: 4, cost: 340, category: "food"),
        Expense(month: 5, cost: 298, category: "food"),
        Expense(month: 6, cost: 356, category: "food")
    ]
    
    var body: some View {
        VStack {
            chartPicker()
            charts()
        }
        .padding(.horizontal)
    }
    
    private func chartPicker() -> some View {
        Picker("Plot type", selection: $type) {
            ForEach(LinePlotType.allCases, id: \.self) { type in
                Text("\(type)")
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private func charts() -> some View {
        switch type {
        case .functions:
            functionsChart()
        case .collection:
            collectionChart()
        }
    }
    
    private func collectionChart() -> some View {
        Chart {
            LinePlot(
                expenses,
                x: .value("Month", \.month),
                y: .value("Cost", \.cost),
                series: .value("Categoty", \.category)
            )
            .foregroundStyle(by: .value("Asset", \.category))
        }
    }
    
    private func functionsChart() -> some View {
        Chart {
            LinePlot(x: "x", y: "y = sin(x)") { sin($0) }
                .foregroundStyle(by: .value("expression", "y=sin(x)"))
                .lineStyle(StrokeStyle(lineWidth: 5, lineCap: .round))
                .opacity(0.8)
            
            
            LinePlot(x: "x", y: "y = cos(x)") { cos($0) }
                .foregroundStyle(by: .value("expression", "y=cos(x)"))
                .lineStyle(StrokeStyle(lineWidth: 5, lineCap: .round))
                .opacity(0.8)
        }
        .chartXScale(domain: -10 ... 10)
        .chartYScale(domain: -10 ... 10)
    }
}

#Preview {
    LinePlotView()
}
