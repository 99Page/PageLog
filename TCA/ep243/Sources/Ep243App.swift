//
//  Ep243App.swift
//  TCA#243
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 VauDium. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct TooltipApp: App {
    
    let tooltipModel = TooltipModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(tooltipModel)
            /// Model로 만든 SwiftData를 schema로 사용하려면 런타임 동안에 어떤 모델을 사용할건지 설정해줘야한다.
            /// 아래 Modifier를 사용해 설정한다.
            /// 모델간에 Relation이 설정되어 있다면 생략 가능하다.
                .modelContainer(
                    for: [TooltipCheck.self, Accomodation.self, Trip.self
                         ]
                )
        }
    }
}

