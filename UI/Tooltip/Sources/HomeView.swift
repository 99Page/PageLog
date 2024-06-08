//
//  HomeView.swift
//  Tooltip
//
//  Created by 노우영 on 6/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(.bear)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all, edges: .vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .bottom) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 80)
                            .foregroundStyle(Color.white)
                    }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .aspectRatio(1.8, contentMode: .fill)
                            .frame(width: 23)
                            .font(.headline)
                            .foregroundStyle(Color.white)
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Bear")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(Color.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(4, contentMode: .fill)
                            .font(.headline)
                            .frame(width: 33)
                            .foregroundStyle(Color.white)
                    })
                }
            })
        }
    }
}

#Preview {
    HomeView()
}
