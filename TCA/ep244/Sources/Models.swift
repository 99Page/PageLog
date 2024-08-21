//
//  Models.swift
//  TCA-244
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct Standup: Equatable, Identifiable, Codable {
    let id: UUID
    var attendees: [Attendee] = []
    var duration = Duration.seconds(60 * 5)
    var meetings: [Meeting] = []
    var theme: Theme = .bubblegum
    var title = ""
    
    var durationPerAttendee: Duration {
        self.duration / self.attendees.count
    }
}

struct Attendee: Equatable, Identifiable, Codable {
    let id: UUID
    var name = ""
}

struct Meeting: Equatable, Identifiable, Codable {
    let id: UUID
    let date: Date
    var transcript: String
}

enum Theme: String, CaseIterable, Identifiable, Codable {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
}

extension Standup {
    static let mock = Standup(
        id: UUID(),
        attendees: [
            Attendee(id: UUID(), name: "Blob"),
            Attendee(id: UUID(), name: "Blob Jr"),
            Attendee(id: UUID(), name: "Blob Sr"),
            Attendee(id: UUID(), name: "Blob Esq"),
            Attendee(id: UUID(), name: "Blob III"),
            Attendee(id: UUID(), name: "Blob I"),
        ],
        duration: .seconds(60),
        meetings: [
            Meeting(id: UUID(), date: Date().addingTimeInterval(-60 * 60 * 24 * 7), transcript: """
                            Baby (baby), got me looking so crazy (crazy)
                            빠져버리는 daydream (daydream)
                            Got me feeling you 너도 말해줄래?
                            누가 내게 뭐라든 남들과는 달라 넌
                            Maybe you could be the one (one)
                            날 믿어봐 한번 I'm not looking for just fun
                            Maybe I could be the one
                            """)
        ],
        theme: .bubblegum,
        title: "Hype boy"
    )
}
