//
//  FactView.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 1/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

struct FactView: View {
    
    @Bindable var model: FactModel
    
    var body: some View {
        Form {
            Section {
                Text("\(model.count)")
                
                Button("Decrement") {
                    model.decrementButtonTapped()
                }
                
                Button("Increment") {
                    model.incrementButtonTapped()
                }
            }
            
            Section {
                Button("Get fact") {
                    model.getFactButtonTapped()
                }
                
                
                if let fact = model.fact {
                    HStack {
                        Text(fact)
                        
                        Spacer()
                        
                        Button {
                            model.favoriteFactButtonTapped()
                        } label: {
                            Image(systemName: "star")
                        }

                    }
                }
            }
            
            if !model.favoriteFacts.isEmpty {
                Section {
                    ForEach(model.favoriteFacts) { fact in
                        Text(fact.value)
                    }
                    .onDelete { indexSet in
                        model.deleteFacts(indexSet: indexSet)
                    }
                } header: {
                    HStack {
                        Text("Favorites (\(model.favoriteFacts.count)")
                        Spacer()
                        Picker("Sort", selection: $model.ordering) {
                            Section {
                                ForEach(FactModel.Ordering.allCases, id: \.self) { ordering in
                                    Text(ordering.rawValue)
                                }
                            } header: {
                                Text("Sort by:")
                            }
                        }
                        .textCase(nil)
                    }
                }
            }
        }
    }
}

#Preview {
    FactView(model: FactModel())
}
