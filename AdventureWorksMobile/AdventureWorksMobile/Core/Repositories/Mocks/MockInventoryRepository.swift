//
//  MockInventoryRepository.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

class MockInventoryRepository: RepositoryProtocol {
    
    private var inventory: [InventoryElement] = [
            InventoryElement(
                id: 1,
                productName: "Adjustable Race",
                productNumber: "AR-5381",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 1,
                locationName: "Tool Crib",
                shelf: "A",
                bin: 1,
                quantity: 195
            ),
            InventoryElement(
                id: 1,
                productName: "Adjustable Race",
                productNumber: "AR-5381",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 6,
                locationName: "Miscellaneous Storage",
                shelf: "B",
                bin: 5,
                quantity: 325
            ),
            InventoryElement(
                id: 1,
                productName: "Adjustable Race",
                productNumber: "AR-5381",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 50,
                locationName: "Subassembly",
                shelf: "A",
                bin: 5,
                quantity: 355
            ),
            InventoryElement(
                id: 2,
                productName: "Bearing Ball",
                productNumber: "BA-8327",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 1,
                locationName: "Tool Crib",
                shelf: "A",
                bin: 2,
                quantity: 427
            ),
            InventoryElement(
                id: 2,
                productName: "Bearing Ball",
                productNumber: "BA-8327",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 6,
                locationName: "Miscellaneous Storage",
                shelf: "B",
                bin: 1,
                quantity: 315
            ),
            InventoryElement(
                id: 2,
                productName: "Bearing Ball",
                productNumber: "BA-8327",
                safetyStockLevel: 1000,
                reorderPoint: 750,
                locationId: 50,
                locationName: "Subassembly",
                shelf: "A",
                bin: 6,
                quantity: 364
            ),
            InventoryElement(
                id: 3,
                productName: "BB Ball Bearing",
                productNumber: "BE-2349",
                safetyStockLevel: 800,
                reorderPoint: 600,
                locationId: 1,
                locationName: "Tool Crib",
                shelf: "A",
                bin: 7,
                quantity: 586
            ),
            InventoryElement(
                id: 3,
                productName: "BB Ball Bearing",
                productNumber: "BE-2349",
                safetyStockLevel: 800,
                reorderPoint: 600,
                locationId: 6,
                locationName: "Miscellaneous Storage",
                shelf: "B",
                bin: 9,
                quantity: 443
            ),
            InventoryElement(
                id: 3,
                productName: "BB Ball Bearing",
                productNumber: "BE-2349",
                safetyStockLevel: 800,
                reorderPoint: 600,
                locationId: 50,
                locationName: "Subassembly",
                shelf: "A",
                bin: 10,
                quantity: 324
            )
    ]
    
    // MARK: - Protocol Implementation
    
    func getAll() async throws -> [InventoryElement] {
        return inventory
    }
    
    func getbyId(_ id: Int) async throws -> InventoryElement? {
        inventory.first(where: { $0.id == id })
    }
    
    func insert(_ item: InventoryElement) async throws -> InventoryElement {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: InventoryElement) async throws {
        throw FeatureError.notImplemented
    }
    
    func delete(_ item: InventoryElement) async throws {
        throw FeatureError.notImplemented
    }
    
}
