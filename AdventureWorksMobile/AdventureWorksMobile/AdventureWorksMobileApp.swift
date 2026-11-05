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
    @Environment(\.orderRepository) private var orderRepository
    @EnvironmentObject var authStatus: AuthStatus
    
    @State private var current: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "products":
                    ProductListView(repository: productRepository)
                        .accessibilityIdentifier("productView")
                case "inventory":
                    InventoryList(repository: inventoryRepository)
                        .accessibilityIdentifier("inventoryView")
                case "orders":
                    OrderListView(repository: orderRepository)
                        .accessibilityIdentifier("ordersView")
                default:
                    WelcomeView()
                        .accessibilityIdentifier("welcomeView")
                }
            }
//            .toolbar {
//                ToolbarItemGroup(placement: .bottomBar) {
//                    Button(action: {
//                        print("Home tapped")
//                    }) {
//                        HStack {
//                            Image(systemName: "house")
//                            Text("Home")
//                        }
//                    }
//                    Spacer()
//
//                    Button(action: {
//                        print("Employees tapped")
//                    }) {
//                        HStack{
//                            Image(systemName: "person.2")
//                            Text("Employees")
//                        }
//                    }
//                    Spacer()
//                    
//                    Button(action: {
//                        print("Products tapped")
//                        current = "products"
//                    }) {
//                        HStack {
//                            Image(systemName: "tag")
//                            Text("Products")
//                        }
//                    }
//                    Spacer()
//                    
//                    Button(action: {
//                        print("Inventory tapped")
//                        current = "inventory"
//                    }) {
//                        HStack {
//                            Image(systemName: "shippingbox")
//                            Text("Inventory")
//                        }
//                    }
//                    Spacer()
//                    
//                    Button(action: {
//                        print("Orders tapped")
//                        current = "orders"
//                    }) {
//                        HStack {
//                            Image(systemName: "receipt")
//                            Text("Orders")
//                        }
//                    }
//                }
//            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Products") {
                            current = "products"
                        }
                        .accessibilityIdentifier("productsViewButton")
                        Button("Inventory") {
                            current = "inventory"
                        }
                        .accessibilityIdentifier("inventoryViewButton")
                        Button("Orders") {
                            current = "orders"
                        }
                        .accessibilityIdentifier("ordersViewButton")
                        Divider()
                        Button("Sign out") {
                            authStatus.clearSession(reason: nil)
                        }
                        .accessibilityIdentifier("signOutButton")
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
