//
//  LoadingView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct LoadableView<Content: View>: View {
    let state: LoadingState
    let retry: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        
        switch state {
            
        case .loading:
            ProgressView("Loading...")
            
        case .failure(let message):
            VStack{
                ContentUnavailableView(
                    "Couldn't Load Data",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
                Button("Try Again", action: retry)
                    .frame(minHeight: 44)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
            
        case .empty:
            ContentUnavailableView(
                "Nothing to Display",
                systemImage: "tray",
                description: Text("There is no data available.")
            )
            
        case .success, .refreshing, .refreshFailure:
            content()
        }
    }
}
