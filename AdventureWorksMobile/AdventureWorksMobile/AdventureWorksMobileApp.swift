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
    @Environment(\.employeeRepository) private var employeeRepository
    @Environment(\.dashboardRepository) private var dashboardRepository
    @EnvironmentObject var authStatus: AuthStatus
    
    @State private var current: String = "dashboard"
    
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "dashboard":
                    DashboardView(repository: dashboardRepository)
                        .accessibilityIdentifier("dashboardView")
                case "products":
                    ProductListView(repository: productRepository)
                        .accessibilityIdentifier("productView")
                case "inventory":
                    InventoryList(repository: inventoryRepository)
                        .accessibilityIdentifier("inventoryView")
                case "orders":
                    OrderListView(repository: orderRepository)
                        .accessibilityIdentifier("ordersView")
                case "employees":
                    EmployeeListView(repository: employeeRepository)
                        .accessibilityIdentifier("employeesView")
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
                        Button("Dashboard") {
                            current = "dashboard"
                        }
                        .accessibilityIdentifier("dashboardViewButton")
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
                        Button("Employees") {
                            current = "employees"
                        }
                        .accessibilityIdentifier("employeesViewButton")
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
