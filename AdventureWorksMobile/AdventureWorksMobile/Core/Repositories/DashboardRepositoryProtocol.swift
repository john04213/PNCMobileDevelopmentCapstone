//
//  DashboardRepositoryProtocol.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/22/26.
//

protocol DashboardRepositoryProtocol {
    func weeklySales() async throws -> [DailySales]
    func bestWorst() async throws -> [ProductSales]
    func lowStock() async throws -> [ProductStock]
    func shifts() async throws -> [ShiftEmployee]
}
