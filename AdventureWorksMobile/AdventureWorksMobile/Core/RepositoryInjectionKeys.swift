//
//  ArtistRepositoryKey.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/11/26.
//

// this is a key for the Environment object to store an ArtistRepository for Dependency Injection
import SwiftUI

struct InventoryRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<InventoryElement> = MockInventoryRepository()
}

struct ProductRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<ProductElement> = MockProductRepository()
}
