//
//  RepositoryProtocol.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/11/26.
//

// <Item> isn't a generic, generics don't work with
// protocols, this is a primary asscoiated type
protocol RepositoryProtocol<Item> {
    
    associatedtype Item: Identifiable, Codable
    
    func getAll() async throws -> [Item]
    func getbyId(_ id: Item.ID) async throws -> Item?
    // adding this return to insert as the server can generate an id
    func insert(_ item: Item) async throws -> Item
    func update(_ item: Item) async throws
    func delete(_ item: Item) async throws
    
}
