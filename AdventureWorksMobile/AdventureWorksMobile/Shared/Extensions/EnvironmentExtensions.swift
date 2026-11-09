//
//  EnvironmentExtensions.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/11/26.
//

import SwiftUI

extension EnvironmentValues {
    
    var inventoryRepository: any RepositoryProtocol<InventoryElement> {
        
        get { self[InventoryRepositoryKey.self] }
        set { self[InventoryRepositoryKey.self] = newValue }
        
    }
    
    var productRepository: any RepositoryProtocol<ProductElement> {
        
        get { self[ProductRepositoryKey.self] }
        set { self[ProductRepositoryKey.self] = newValue }
        
    }
    
    var orderRepository: any RepositoryProtocol<OrderElement> {
        
        get { self[OrderRepositoryKey.self] }
        set { self[OrderRepositoryKey.self] = newValue }

    }

    var employeeRepository: any EmployeeRepositoryProtocol {

        get { self[EmployeeRepositoryKey.self] }
        set { self[EmployeeRepositoryKey.self] = newValue }

    }

    var dashboardRepository: any DashboardRepositoryProtocol {

        get { self[DashboardRepositoryKey.self] }
        set { self[DashboardRepositoryKey.self] = newValue }
        
    }
    
}
