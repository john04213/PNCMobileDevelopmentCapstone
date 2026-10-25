//
//  DakeDashboardRepository.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/22/26.
//

import Foundation
@testable import AdventureWorksMobile
@MainActor
class FakeDashboardRepository: @MainActor DashboardRepositoryProtocol {
    var lowStockError: Error? = nil
    var lowStockCallCount = 0
    var salesCallCount = 0
    func weeklySales () async throws -> [DailySales] {
        salesCallCount += 1
        return[DailySales(salesDate: "2025-01-01", totalSales: 25.0, totalProfit: 100.00)]
    }
    
    func bestWorst() async throws -> [ProductSales] {
        return [ProductSales(productId: 1, productName: "Bearing Balls", unitsSold: 25, unitsInStock: 100)]
    }
    
    func lowStock() async throws -> [ProductStock] {
        lowStockCallCount += 1
        if let lowStockError { throw lowStockError}
        return [ProductStock(productId: 1, productName: "Bearing Balls", stockLevel: 100, reorderPoint: 200)]
    }
    
    func shifts() async throws -> [ShiftEmployee] {
        return [ShiftEmployee(employeeId:203, firstName: "Ron",middleName:"Aaron", lastName: "Weasely",suffix:nil, shift:"Day" )]
    }
    
    
    
}


