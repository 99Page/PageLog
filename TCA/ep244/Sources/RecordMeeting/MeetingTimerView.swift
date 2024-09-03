//
//  MeetingTimerView.swift
//  TCA-244
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct MeetingTimerView: View {
    let standup: Standup
    let speakerIndex: Int
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Group {
                        if self.speakerIndex
                            < self.standup.attendees.count {
                            Text(
                                self.standup.attendees[self.speakerIndex]
                                    .name
                            )
                        } else {
                            Text("Someone")
                        }
                    }
                    .font(.title)
                    Text("is speaking")
                    Image(systemName: "mic.fill")
                        .font(.largeTitle)
                        .padding(.top)
                }
                .foregroundStyle(self.standup.theme.accentColor)
            }
            .overlay {
                ForEach(
                    Array(self.standup.attendees.enumerated()),
                    id: \.element.id
                ) { index, attendee in
                    if index < self.speakerIndex + 1 {
                        SpeakerArc(
                            totalSpeakers: self.standup.attendees.count,
                            speakerIndex: index
                        )
                        .rotation(Angle(degrees: -90))
                        .stroke(
                            self.standup.theme.mainColor, lineWidth: 12
                        )
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct SpeakerArc: Shape {
    let totalSpeakers: Int
    let speakerIndex: Int
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(
            rect.size.width, rect.size.height
        ) - 24
        let radius = diameter / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: self.startAngle,
                endAngle: self.endAngle,
                clockwise: false
            )
        }
    }
    private var degreesPerSpeaker: Double {
        360 / Double(self.totalSpeakers)
    }
    private var startAngle: Angle {
        Angle(
            degrees: self.degreesPerSpeaker
            * Double(self.speakerIndex)
            + 1
        )
    }
    private var endAngle: Angle {
        Angle(
            degrees: self.startAngle.degrees
            + self.degreesPerSpeaker
            - 1
        )
    }
}
