//
//  StandupFormView.swift
//  PageScrumdinger
//
//  Created by 노우영 on 8/24/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI


@Observable
class StandupFormModel: Identifiable {
    let id = UUID()
    var standupForm: Standup?
    weak var standupActionDelegate: StandupActionDelegate?
}

protocol StandupActionDelegate: AnyObject {
    func onSaveButtonTapped(newStandup: Standup)
}

struct StandupFormView: View {
    
    @Bindable var model: StandupFormModel
    
    init(model: StandupFormModel, actionDelegate: StandupActionDelegate? = nil) {
        self.model = model
        model.standupActionDelegate = actionDelegate
    }
    
    var body: some View {
        Form {
            Section {
                
                HStack {
                    
                }
                
                
            } header: {
                Text("Standup Info")
            }
            
            Section {
                Button {
                    
                } label: {
                    Text("Add attendee")
                }
            } header: {
                Text("ATTENDEES")
            }
        }
    }
}
