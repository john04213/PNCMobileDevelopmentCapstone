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
            ProgressView(message)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview{
    LoadingView(message: "Loading...")
}
