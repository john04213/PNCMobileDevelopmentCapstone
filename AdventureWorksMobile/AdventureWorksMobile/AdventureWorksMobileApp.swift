//
//  AdventureWorksMobileApp.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct AdventureWorksMobileApp: View {
    @Environment(\.productRepository) private var productRepository
    @Environment(\.inventoryRepository) private var inventoryRepository
    @EnvironmentObject var authStatus: AuthStatus
    
    @State private var current: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "inventory":
                    InventoryList(repository1: productRepository, repository2: inventoryRepository)
                        .accessibilityIdentifier("inventoryView")
                default:
                    WelcomeView()
                        .accessibilityIdentifier("welcomeView")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Inventory") {
                            current = "inventory"
                        }
                        .accessibilityIdentifier("inventoryViewButton")
                        Divider()
                        Button("Log out") {
                            authStatus.updateLoginStatus(success: false)
                        }
                        .accessibilityIdentifier("logOutButton")
                    }
                    label: {
                        Label("View", systemImage: "line.3.horizontal")
                    }
                    .accessibilityIdentifier("mainMenuButton")
                }
            }
        }
    }
}
