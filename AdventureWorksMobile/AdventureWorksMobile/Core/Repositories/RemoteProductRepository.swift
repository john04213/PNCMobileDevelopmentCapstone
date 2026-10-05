//
//  RemoteProductRepository.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import Foundation

class RemoteProductRepository: RemoteRepositoryBase<ProductElement>, RepositoryProtocol {
    
    private let urlBase: String
    
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
    
    func getAll() async throws -> [ProductElement] {
        
        let urlString = "\(urlBase)/Product"
        return try await fetchAll(urlString)
        
    }
    
    func getbyId(_ id: Int) async throws -> ProductElement? {
        
        let urlString = "\(urlBase)/Product/\(id)"
        return try await fetchOne(urlString)
        
    }
    
    func insert(_ item: ProductElement) async throws -> ProductElement {
        
        let urlString = "\(urlBase)/Product"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: ProductElement) async throws {
        
        let urlString = "\(urlBase)/Product/\(item.id)"
        try await put(urlString, send: item)
        
    }
    
    func delete(_ item: ProductElement) async throws {
        
        let urlString = "\(urlBase)/Product/\(item.id)"
        try await del(urlString)
        
    }
    
}
