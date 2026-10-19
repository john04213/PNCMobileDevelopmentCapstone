//
//  ErrorStateView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI


struct ErrorStateView: View{
    var message: String
    var retryAction: () -> Void
    var body: some View {
        VStack {
            Image(systemName:"exclamationmark.triangle" )
                .accessibilityHidden(true)
                .foregroundStyle(.red)
            Text(message)
            Button("Try again") {
                Task {
                    retryAction()
                }
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("retryButton")
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(message: "Something went wrong", retryAction: {})
}
