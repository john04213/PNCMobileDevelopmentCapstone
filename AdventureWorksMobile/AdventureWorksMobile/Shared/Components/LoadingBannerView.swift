//
//  LoadingBannerView.swift
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
        Group {
            switch state {

            case .idle, .loading, .empty, .failed:
                EmptyView()

            case .loaded:
                if !refreshErrorMessage.isEmpty {
                    VStack {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                                .accessibilityHidden(true)
                            banner("Couldn't refresh \(itemName).")
                        }
                        banner(refreshErrorMessage)
                    }
                } else if isLoading {
                    banner("Refreshing \(itemName)...")
                } else {
                    banner("\(itemName.capitalized) loaded · Pull down to refresh")
                }
            }
        }
        .onChange(of: refreshErrorMessage) { _, newValue in
            if !newValue.isEmpty {
                AccessibilityNotification.Announcement("Couldn't refresh \(itemName). \(newValue)").post()
            }
        }
    }

    private func banner(_ text: String) -> some View {
        HStack {
            Text(text).font(.subheadline)
            Spacer()
        }
        .foregroundStyle(.primary)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)

    }

}

#Preview {
    LoadingBannerView(
        state: .loaded,
        isLoading: false,
        refreshErrorMessage: "Check your connection and try again.",
        itemName: "products"
    )
}
