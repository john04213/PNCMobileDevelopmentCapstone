//
//  SyncStatusView.swift
//  AdventureWorksMobile
//
//  Created by Daniela C. on 10/14/26.
//

import SwiftUI

struct LoadingBannerView: View {
    
    let state: LoadState
    let isLoading: Bool
    let refreshErrorMessage: String
    let itemName: String
    
    var body: some View {
        switch state {
            
        case .idle, .loading, .empty, .failed:
            EmptyView()
            
        case .loaded:
            if !refreshErrorMessage.isEmpty {
                banner("Couldn't refresh \(itemName). Showing existing data.")
            } else if isLoading {
                banner("Refreshing \(itemName)...")
            } else {
                banner("\(itemName.capitalized) loaded · Pull down to refresh")
            }
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

#Preview{
    LoadingBannerView(
        state: LoadState.loading,
        isLoading: false,
        refreshErrorMessage: "",
        itemName: "Products"
    )
}
