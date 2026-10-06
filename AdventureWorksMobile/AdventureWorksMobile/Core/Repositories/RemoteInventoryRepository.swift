//
//  RemoteInventoryRepository.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import Foundation

class RemoteInventoryRepository: RemoteRepositoryBase<InventoryElement>, RepositoryProtocol {
    
    private let urlBase: String
    
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
    
    func getAll() async throws -> [InventoryElement] {
        
        let urlString = "\(urlBase)/Inventory"
        return try await fetchAll(urlString)
        
    }
    
    func getbyId(_ id: Int) async throws -> InventoryElement? {
        
        let urlString = "\(urlBase)/Inventory/\(id)"
        return try await fetchOne(urlString)
        
    }
    
    func insert(_ item: InventoryElement) async throws -> InventoryElement {
        
        let urlString = "\(urlBase)/Inventory"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: InventoryElement) async throws {
        
        let urlString = "\(urlBase)/Inventory/\(item.id)"
        try await put(urlString, send: item)
        
    }
    
    func delete(_ item: InventoryElement) async throws {
        
        let urlString = "\(urlBase)/Inventory/\(item.id)"
        try await del(urlString)
        
    }
    
}
