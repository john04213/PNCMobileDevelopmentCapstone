//
//  InventoryElement.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import SwiftUI
import Foundation

class InventoryElement: Identifiable, Hashable, Codable {
    
    let productId: Int
    let productName: String
    let productNumber: String
    let safetyStockLevel: Int
    let reorderPoint: Int
    let locationId: Int
    let locationName: String
    let shelf: String
    let bin: Int
    let quantity: Int
    
    var id: String {
        "\(productId) - \(locationName) - \(shelf) - \(bin)"
    }
    
    init(productId: Int, productName: String, productNumber: String, safetyStockLevel: Int, reorderPoint: Int, locationId: Int, locationName: String, shelf: String, bin: Int, quantity: Int) {
        self.productId = productId
        self.productName = productName
        self.productNumber = productNumber
        self.safetyStockLevel = safetyStockLevel
        self.reorderPoint = reorderPoint
        self.locationId = locationId
        self.locationName = locationName
        self.shelf = shelf
        self.bin = bin
        self.quantity = quantity
    }
    
    static func == (lhs: InventoryElement, rhs: InventoryElement) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
