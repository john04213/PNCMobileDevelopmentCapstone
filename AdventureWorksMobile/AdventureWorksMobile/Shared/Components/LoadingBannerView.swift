//
//  SyncStatusView.swift
//  AdventureWorksMobile
//
//  Created by user304506 on 10/14/26.
//

import SwiftUI

struct LoadingStateView: View {
    
    let state: LoadingState
    
    var body: some View {
        switch state {
        case .loading, .empty, .failure:
            EmptyView()
            
        case .success:
            banner("Inventory loaded · Pull down to refresh")
            
        case .refreshing:
            banner("Refreshing...")
            
        case .refreshFailure(let message):
            banner(message)
        }
    }
    
    private func banner(_ text: String) -> some View{
            HStack{
                Text(text).font(.subheadline)
                Spacer()
            }
            .foregroundStyle(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)
            
        }
    
}
