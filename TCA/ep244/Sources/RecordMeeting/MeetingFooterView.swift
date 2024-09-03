//
//  MeetingFooterView.swift
//  TCA-244
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct MeetingFooterView: View {
  let standup: Standup
  var nextButtonTapped: () -> Void
  let speakerIndex: Int

  var body: some View {
    VStack {
      HStack {
        if self.speakerIndex
          < self.standup.attendees.count - 1 {
          Text(
            """
            Speaker \(self.speakerIndex + 1) \
            of \(self.standup.attendees.count)
            """
          )
        } else {
          Text("No more speakers.")
        }
        Spacer()
        Button(action: self.nextButtonTapped) {
          Image(systemName: "forward.fill")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}
