//
//  FailingInventoryRepository.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/19/26.
//

import Foundation
@testable import AdventureWorksMobile

@MainActor
class FailingInventoryRepository: @MainActor RepositoryProtocol {

    var errorToThrow: Error = URLError(.notConnectedToInternet)
    var shouldFail = true
    var itemsToReturn: [InventoryElement] = []
    var getAllCallCount = 0
    
    func getAll() async throws -> [InventoryElement] {
        getAllCallCount += 1
        if shouldFail{
            throw errorToThrow
        }
        return itemsToReturn
    }
    
    func getbyId(_ id: Item.ID) async throws -> Item? {
        throw FeatureError.notImplemented
    }
    
    func insert(_ item: Item) async throws -> Item {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: Item) async throws {
        throw FeatureError.notImplemented
    }
    func delete(_ item: Item) async throws {
        throw FeatureError.notImplemented
    }
}
