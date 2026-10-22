//
//  OrderLineItem.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/20/26.
//

struct OrderLineItem: Identifiable, Hashable, Codable {
    let id: Int
    let orderNumber: Int
    let productName: String
    let orderQty: Int
    let unitPrice: Double
    let lineTotal: Double
    
    static func == (lhs: OrderLineItem, rhs: OrderLineItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
