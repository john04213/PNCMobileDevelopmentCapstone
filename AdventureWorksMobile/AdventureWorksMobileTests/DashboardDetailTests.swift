//
//  DashboardDetailTests.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/22/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct DashboardDetailTests {

    // Eight days of sales: day 1 sold 1, day 2 sold 2, and so on. The profit is double the sales.
    private func viewModelWithEightDays() -> DashboardView.ViewModel {
        let vm = DashboardView.ViewModel(repository: FakeDashboardRepository())
        vm.dailySales = (1...8).map { day in
            DailySales(salesDate: "2025-01-0\(day)T00:00:00",
                       totalSales: Double(day),
                       totalProfit: Double(day) * 2)
        }
        return vm
    }

    @Test
    func lastWeekSalesKeepsOnlyTheLastSevenDays() {
        let vm = viewModelWithEightDays()

        #expect(vm.lastWeekSales.count == 7)
        #expect(vm.lastWeekSales.first?.salesDate == "2025-01-02T00:00:00")
        #expect(vm.lastWeekSales.last?.salesDate == "2025-01-08T00:00:00")
    }

    @Test
    func weekTotalAndProfitAddUpTheSameSevenDays() {
        let vm = viewModelWithEightDays()

        #expect(vm.weekTotal == 35.0)
        #expect(vm.weekProfit == 70.0)
    }

    @Test
    func lowStockShowsTheOneFurthestBelowItsReorderPointFirst() {
        let vm = DashboardView.ViewModel(repository: FakeDashboardRepository())
        vm.lowStock = [
            ProductStock(productId: 1, productName: "Alpha", stockLevel: 100, reorderPoint: 200),
            ProductStock(productId: 2, productName: "Bravo", stockLevel: 0, reorderPoint: 200),
            ProductStock(productId: 3, productName: "Charlie", stockLevel: 0, reorderPoint: 100)
        ]

        let names = vm.lowStockByShortfall.map { product in
            product.productName
        }

        // Bravo is 200 short. Alpha and Charlie are both 100 short, so they go by name.
        #expect(names == ["Bravo", "Alpha", "Charlie"])
    }

    @Test
    func lowStockStatusIsSaidInWords() {
        let outOfStock = ProductStock(productId: 1, productName: "A", stockLevel: 0, reorderPoint: 100)
        let below = ProductStock(productId: 2, productName: "B", stockLevel: 50, reorderPoint: 100)
        let atPoint = ProductStock(productId: 3, productName: "C", stockLevel: 100, reorderPoint: 100)

        #expect(outOfStock.statusText == "Out of stock")
        #expect(below.statusText == "Below reorder point")
        #expect(atPoint.statusText == "At reorder point")
    }

    @Test
    func strongIsTheFirstProductAndWeakIsTheLast() {
        let vm = DashboardView.ViewModel(repository: FakeDashboardRepository())
        vm.productSales = [
            ProductSales(productId: 1, productName: "Best", unitsSold: 42, unitsInStock: 8),
            ProductSales(productId: 2, productName: "Worst", unitsSold: 1, unitsInStock: 300)
        ]

        #expect(vm.strongPerformer?.productName == "Best")
        #expect(vm.weakPerformer?.productName == "Worst")
    }

    @Test
    func noProductSalesMeansNoPerformers() {
        let vm = DashboardView.ViewModel(repository: FakeDashboardRepository())

        #expect(vm.strongPerformer == nil)
        #expect(vm.weakPerformer == nil)
    }
}
