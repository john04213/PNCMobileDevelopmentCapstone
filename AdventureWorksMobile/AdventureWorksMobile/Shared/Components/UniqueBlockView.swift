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
                    .lineLimit(1)
                if let (sub) = subTitle {
                    Text(sub)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(String(format: "$%.2f", total))
                .bold()
                .lineLimit(1)
        }
    }
}
