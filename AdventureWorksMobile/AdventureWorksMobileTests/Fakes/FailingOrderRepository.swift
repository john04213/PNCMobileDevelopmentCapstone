//
//  FailingOrderRepository.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/28/26.
//

import Foundation

@testable import AdventureWorksMobile

@MainActor
class FailingOrderRepository:@MainActor RepositoryProtocol {
    var errorToThrow: Error = URLError(.notConnectedToInternet)
    var shouldFail = true
    var itemsToReturn: [OrderElement] = []
    
    func getAll() async throws -> [OrderElement] {
        if shouldFail {throw errorToThrow}
        return itemsToReturn
    }
    
    func getbyId(_ id: Int) async throws -> OrderElement? {
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
