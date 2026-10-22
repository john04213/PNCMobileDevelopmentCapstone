//
//  DashboardBox.swift
//  
//
//  Created by Harris on 10/21/26.
//

import SwiftUI

struct DashboardBox: View {

    let title: String
    let systemImage: String
    let color: Color
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value), \(detail)")
    }
}

#Preview {
    DashboardBox(title: "Weekly Sales",
                 systemImage: "dollarsign.circle",
                 color: .blue,
                 value: "$12,388",
                 detail: "Up 6.2% vs prior week")
}
