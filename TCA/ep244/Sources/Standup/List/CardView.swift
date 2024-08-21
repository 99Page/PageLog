//
//  CardView.swift
//  TCA-244
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct CardView: View {
    let scrum: Standup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(scrum.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(scrum.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel("\(scrum.attendees.count) attendees")
                Spacer()
                Label("\(scrum.duration.formatted(.units()))", systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
    }
}
