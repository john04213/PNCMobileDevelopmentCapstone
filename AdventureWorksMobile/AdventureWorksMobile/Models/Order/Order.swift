//
//  Order.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/20/26.
//

import Foundation

struct Order: Identifiable, Hashable {
    let id: Int
    let businessEntityId: Int
    let customerId: Int
    let storeName: String
    let orderDate: String
    let contactFirstName: String
    let contactLastName: String
    let shipDate: String
    
    var name: String{
        "SO\(id)"
    }
    
    var lineItems: [OrderLineItem]
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
