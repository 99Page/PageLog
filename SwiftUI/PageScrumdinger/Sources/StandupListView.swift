//
//  StandupListView.swift
//  PageScrumdinger
//
//  Created by 노우영 on 8/24/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

@Observable
final class StandupListModel: Identifiable {
    let id = UUID()
    var standupFormModel: StandupFormModel?
    var standups: [Standup] = []
}

extension StandupListModel: StandupActionDelegate {
    func onSaveButtonTapped(newStandup: Standup) {
        standups.append(newStandup)
    }
}

struct StandupListView: View {
    
    @State var model = StandupListModel()
    
    var body: some View {
        List {
            
        }
        .navigationTitle("Daily Standups")
        .sheet(item: $model.standupFormModel) { standupFormModel in
            StandupFormView(model: standupFormModel, actionDelegate: model)
        }
        .toolbar {
            ToolbarItem {
                Button("Add") {
                    
                }
            }
        }
    }
}
