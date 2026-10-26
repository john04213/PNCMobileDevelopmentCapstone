//
//  RemoteOrderRepository.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/19/26.
//

import Foundation

class RemoteOrderRepository: RemoteRepositoryBase<OrderElement>, RepositoryProtocol {
    
    private let urlBase: String
    
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
    
    func getAll() async throws -> [OrderElement] {
        
        let urlString = "\(urlBase)/Order/store"
        return try await fetchAll(urlString)
        
    }
    
    func getbyId(_ id: Int) async throws -> OrderElement? {
        
        let urlString = "\(urlBase)/Order/store/\(id)"
        return try await fetchOne(urlString)
        
    }
    
    func insert(_ item: OrderElement) async throws -> OrderElement {
        
        let urlString = "\(urlBase)/Order/store"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: OrderElement) async throws {
        
        let urlString = "\(urlBase)/Order/store/\(item.id)"
        try await put(urlString, send: item)
        
    }
    
    func delete(_ item: OrderElement) async throws {
        
        let urlString = "\(urlBase)/Order/store/\(item.id)"
        try await del(urlString)
        
    }
    
}
