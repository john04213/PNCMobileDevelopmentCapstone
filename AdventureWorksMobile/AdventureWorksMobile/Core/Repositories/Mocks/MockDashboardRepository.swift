//
//  MockDashboardRepository.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/9/26.
//

// The default Dashboard repository for previews. The real one is injected in RootView.
class MockDashboardRepository: DashboardRepositoryProtocol {

    func weeklySales() async throws -> [DailySales] {
        return [
            DailySales(salesDate: "2014-06-24T00:00:00", totalSales: 1200.50, totalProfit: 300.25),
            DailySales(salesDate: "2014-06-25T00:00:00", totalSales: 980.00, totalProfit: 240.00)
        ]
    }

    func bestWorst() async throws -> [ProductSales] {
        return [
            ProductSales(productId: 1, productName: "Bearing Balls", unitsSold: 25, unitsInStock: 100),
            ProductSales(productId: 2, productName: "Adjustable Race", unitsSold: 3, unitsInStock: 40)
        ]
    }

    func lowStock() async throws -> [ProductStock] {
        return [
            ProductStock(productId: 1, productName: "Bearing Balls", stockLevel: 100, reorderPoint: 200)
        ]
    }

    func shifts() async throws -> [ShiftEmployee] {
        return [
            ShiftEmployee(employeeId: 203, firstName: "Ron", middleName: "Aaron", lastName: "Weasely", suffix: nil, shift: "Day")
        ]
    }
}
