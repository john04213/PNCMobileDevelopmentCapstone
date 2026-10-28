//
//  ActiveFiltersBar.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/27/26.
//

import SwiftUI
struct ActiveFiltersBar: View {
    let labels:  [String]
    let clearAll: () -> Void
    
    var body: some View {
        if !labels.isEmpty{
            HStack{
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(labels, id: \.self) {label in
                            Text(label)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(.thinMaterial, in: Capsule() )
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Active filters: \(labels.joined(separator: ", "))")
                }
                Button {
                        clearAll()
                }
                label: {
                    Text("Clear all")
                        .frame(minHeight: 44)
                }
                .accessibilityIdentifier("clearFiltersButton")
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    ActiveFiltersBar(labels: ["Search: \"race\"", "Category: \"T-Shirts\""], clearAll: {})
}
