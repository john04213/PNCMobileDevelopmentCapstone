//
//  EmptyStateView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct EmptyStateView: View {
    var message: String
    var body: some View{
        VStack(spacing: 10){
            Image(systemName: "tray")
                .accessibilityHidden(true)
            Text(message)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview{
    EmptyStateView(message: "No data found")
}
