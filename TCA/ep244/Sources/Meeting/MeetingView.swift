//
//  MeetingView.swift
//  TCA-244
//
//  Created by 노우영 on 9/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct MeetingView: View {
  let meeting: Meeting
  let standup: Standup

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Divider()
          .padding(.bottom)
        Text("Attendees")
          .font(.headline)
        ForEach(self.standup.attendees) { attendee in
          Text(attendee.name)
        }
        Text("Transcript")
          .font(.headline)
          .padding(.top)
        Text(self.meeting.transcript)
      }
    }
    .navigationTitle(Text(self.meeting.date, style: .date))
    .padding()
  }
}

#Preview {
    MeetingView(meeting: .mock, standup: .mock)
}
