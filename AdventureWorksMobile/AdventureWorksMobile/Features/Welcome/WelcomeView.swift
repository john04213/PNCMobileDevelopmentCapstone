//
//  WelcomeView.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/14/26.
//

import SwiftUI

struct WelcomeView: View {
    let greenBlue: [Color] = [.green, .blue]
    let blueGreen: [Color] = [.blue, .green]
    var body: some View {
        VStack {
            Text("Welcome to our SwiftUI capstone project!")
                .multilineTextAlignment(.center)
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: greenBlue,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

#Preview {
    WelcomeView()
}
