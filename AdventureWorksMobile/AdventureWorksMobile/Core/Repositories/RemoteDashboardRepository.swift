//
//  RemoteDashboardRepository.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/22/26.
//

import Foundation

class RemoteDashboardRepository: DashboardRepositoryProtocol{
    
    private let urlBase: String
    private let salesApi: RemoteRepositoryBase<DailySales>
    private let bestWorstApi: RemoteRepositoryBase<ProductSales>
    private let lowStockApi: RemoteRepositoryBase<ProductStock>
    private let shiftsApi: RemoteRepositoryBase<ShiftEmployee>
    
    init(urlBase:String, authStatus: AuthStatus ){
        self.urlBase = urlBase
        
        salesApi = RemoteRepositoryBase<DailySales>(authStatus: authStatus)
        bestWorstApi = RemoteRepositoryBase<ProductSales>(authStatus: authStatus)
        lowStockApi = RemoteRepositoryBase<ProductStock>(authStatus: authStatus)
        shiftsApi = RemoteRepositoryBase<ShiftEmployee>(authStatus: authStatus)
        
    }
    
    func weeklySales() async throws -> [DailySales] {
      try await salesApi.fetchAll("\(urlBase)/Dashboard/weekly-sales")
    }
        
    
    
    func bestWorst() async throws -> [ProductSales] {
        try await bestWorstApi.fetchAll("\(urlBase)/Dashboard/best-worst")
    }
    
    func lowStock() async throws -> [ProductStock] {
        try await lowStockApi.fetchAll("\(urlBase)/Dashboard/low-stock")
    }
    
    func shifts() async throws -> [ShiftEmployee] {
        try await shiftsApi.fetchAll("\(urlBase)/Dashboard/shifts")
    }
    
    
    
}
