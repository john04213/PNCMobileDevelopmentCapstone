//
//  LoadingView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct LoadingView: View {
    var message: String
    var body: some View {
        VStack(){
            ProgressView {
                Text(message)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            AccessibilityNotification.Announcement(message).post()
        }
    }
}

#Preview{
    LoadingView(message: "Loading...")
}
