//
//  RootView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI
internal import CoreData

@main
struct RootView: App {
    let awAPIURL = "https://api.bootcampcentral.com/api"
    @StateObject var authStatus = AuthStatus()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if authStatus.isLoggedIn {
                AdventureWorksMobileApp()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environment(\.productRepository, RemoteProductRepository(urlBase: awAPIURL, authStatus: authStatus))
                    .environment(\.inventoryRepository, RemoteInventoryRepository(urlBase: awAPIURL, authStatus: authStatus))
                    .environmentObject(authStatus)
            }
            else {
                LoginView()
                    .environmentObject(authStatus)
            }
        }
    }
}
