//
//  ActiveFiltersBars.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/27/26.
//

import SwiftUI
struct ActiveFiltersBars: View {
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
            }
        }
    }
}
