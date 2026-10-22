//
//  MockOrderRepository.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/19/26.
//

import Foundation

class MockOrderRepository: RepositoryProtocol {
    
    private var orders: [OrderElement] = [
        OrderElement(
            id: 110562,
            businessEntityId: 1092,
            customerId: 29847,
            storeName: "Good Toys",
            orderDate: "Date(2014-05-01T00:00:00",
            contactFirstName: "Dave",
            contactLastName: "Hodgson",
            orderNumber: 71774,
            productName: "ML Road Frame-W - Yellow, 48",
            orderQty: 1,
            unitPrice: 356.8980,
            lineTotal: 356.898000,
            shipDate: "2014-05-08T00:00:00"
        ),
        OrderElement(
            id: 110563,
            businessEntityId: 1092,
            customerId: 29847,
            storeName: "Good Toys",
            orderDate: "2014-05-01T00:00:00",
            contactFirstName: "Dave",
            contactLastName: "Hodgson",
            orderNumber: 71774,
            productName: "ML Road Frame-W - Yellow, 38",
            orderQty: 1,
            unitPrice: 356.8980,
            lineTotal: 356.898000,
            shipDate: "2014-05-08T00:00:00"
        ),
        OrderElement(
            id: 110564,
            businessEntityId: 1804,
            customerId: 30031,
            storeName: "Cycle Clearance",
            orderDate: "2014-05-01T00:00:00",
            contactFirstName: "Alan",
            contactLastName: "Steiner",
            orderNumber: 71775,
            productName: "Touring-1000 Blue, 46",
            orderQty: 1,
            unitPrice: 1430.4420,
            lineTotal: 1430.442000,
            shipDate: "2014-05-08T00:00:00"
        ),
        OrderElement(
            id: 110565,
            businessEntityId: 1804,
            customerId: 30031,
            storeName: "Cycle Clearance",
            orderDate: "2014-05-01T00:00:00",
            contactFirstName: "Alan",
            contactLastName: "Steiner",
            orderNumber: 71775,
            productName: "Front Brakes",
            orderQty: 3,
            unitPrice: 63.9000,
            lineTotal: 191.700000,
            shipDate: "2014-05-08T00:00:00"
        )
    ]
    
    // MARK: - Protocol Implementation
    
    func getAll() async throws -> [OrderElement] {
        return orders
    }
    
    func getbyId(_ id: Int) async throws -> OrderElement? {
        return orders.first(where: { $0.id == id })
    }
    
    func insert(_ item: OrderElement) async throws -> OrderElement {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: OrderElement) async throws {
        throw FeatureError.notImplemented
    }
    
    func delete(_ item: OrderElement) async throws {
        throw FeatureError.notImplemented
    }
    
}
