//
//  OrderElement.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import Foundation

class OrderElement: Identifiable, Hashable, Codable {
    let id: Int
    let businessEntityId: Int
    let customerId: Int
    let storeName: String
    let orderDate: String
    let contactFirstName: String
    let contactLastName: String
    let orderNumber: Int
    let productName: String
    let orderQty: Int
    let unitPrice: Double
    let lineTotal: Double
    let shipDate: String
    
    var name: String{
        "SO\(id)"
    }

    init(id: Int, businessEntityId: Int, customerId: Int, storeName: String, orderDate: String, contactFirstName: String, contactLastName: String, orderNumber: Int, productName: String, orderQty: Int, unitPrice: Double, lineTotal: Double, shipDate: String) {
        self.id = id
        self.businessEntityId = businessEntityId
        self.customerId = customerId
        self.storeName = storeName
        self.orderDate = orderDate
        self.contactFirstName = contactFirstName
        self.contactLastName = contactLastName
        self.orderNumber = orderNumber
        self.productName = productName
        self.orderQty = orderQty
        self.unitPrice = unitPrice
        self.lineTotal = lineTotal
        self.shipDate = shipDate
    }
    
    static func == (lhs: OrderElement, rhs: OrderElement) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
