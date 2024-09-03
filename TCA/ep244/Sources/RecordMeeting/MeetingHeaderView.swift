//
//  MeetingHeaderView.swift
//  TCA-244
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct MeetingHeaderView: View {
    let secondsElapsed: Int
    let durationRemaining: Duration
    let theme: Theme
    
    var body: some View {
        VStack {
            ProgressView(value: self.progress)
                .progressViewStyle(
                    MeetingProgressViewStyle(theme: self.theme)
                )
            HStack {
                VStack(alignment: .leading) {
                    Text("Time Elapsed")
                        .font(.caption)
                    Label(
                        Duration.seconds(self.secondsElapsed)
                            .formatted(.units()),
                        systemImage: "hourglass.bottomhalf.fill"
                    )
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Time Remaining")
                        .font(.caption)
                    Label(
                        self.durationRemaining.formatted(.units()),
                        systemImage: "hourglass.tophalf.fill"
                    )
                    .font(.body.monospacedDigit())
                    .labelStyle(.trailingIcon)
                }
            }
        }
        .padding([.top, .horizontal])
    }
    
    private var totalDuration: Duration {
       .seconds(self.secondsElapsed) + self.durationRemaining
     }

     private var progress: Double {
       guard self.totalDuration > .seconds(0)
       else { return 0 }
       return Double(self.secondsElapsed)
         / Double(self.totalDuration.components.seconds)
     }
}

struct MeetingProgressViewStyle: ProgressViewStyle {
    var theme: Theme
    
    func makeBody(
        configuration: Configuration
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(self.theme.accentColor)
                .frame(height: 20)
            
            ProgressView(configuration)
                .tint(self.theme.mainColor)
                .frame(height: 12)
                .padding(.horizontal)
        }
    }
}
