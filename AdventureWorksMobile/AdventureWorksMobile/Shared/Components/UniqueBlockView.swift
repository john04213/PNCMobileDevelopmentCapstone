//
//  UniqueBlockView.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/20/26.
//

import SwiftUI

struct UniqueBlockView: View {
    var title: String
    var subTitle: String?
    var total: Double

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                if let (sub) = subTitle {
                    Text(sub)
                        .foregroundStyle(.primary)
                }
            }
            Spacer()
            Text(String(format: "$%.2f", total))
                .bold()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(subTitle ?? "") \(String(format: "$%.2f", total))")    }
}
