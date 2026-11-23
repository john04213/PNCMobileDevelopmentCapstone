//
//  DashboardView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var viewModel: ViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    init(repository: any DashboardRepositoryProtocol) {
        viewModel = ViewModel(repository: repository)
    }
    
    private var rowLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout())
        : AnyLayout(HStackLayout())
    }
    
    private var dashboardBoxes: some View {
        VStack {
            rowLayout {
                NavigationLink {
                    WeeklySalesDetailView(viewModel: viewModel)
                } label: {
                    DashboardBox(title: "Weekly Sales",
                                 systemImage: "dollarsign.circle",
                                 color: .gray,
                                 value: viewModel.weekTotal.formatted(.currency(code: "USD")),
                                 detail: "Last 7 days")
                }
                .buttonStyle(.plain)
                NavigationLink {
                    LowStockDetailView(viewModel: viewModel)
                } label: {
                    DashboardBox(title: "Low Stock",
                                 systemImage: "shippingbox",
                                 color: .gray,
                                 value: "\(viewModel.lowStock.count)",
                                 detail: "Products to reorder")
                }
                .buttonStyle(.plain)
            }
            rowLayout {
                NavigationLink {
                    ProductPerformanceDetailView(viewModel: viewModel,
                                                 title: "Strong Performer",
                                                 summary: "Selling well",
                                                 isStrong: true)
                } label: {
                    DashboardBox(title: "Strong Performer",
                                 systemImage: "chart.line.uptrend.xyaxis",
                                 color: .gray,
                                 value: viewModel.productSales.first?.productName ?? "No data",
                                 detail: "Units sold: \(viewModel.productSales.first?.unitsSold ?? 0)")
                }
                .buttonStyle(.plain)
                NavigationLink {
                    ProductPerformanceDetailView(viewModel: viewModel,
                                                 title: "Weak Performer",
                                                 summary: "Selling slowly",
                                                 isStrong: false)
                } label: {
                    DashboardBox(title: "Weak Performer",
                                 systemImage: "chart.line.downtrend.xyaxis",
                                 color: .gray,
                                 value: viewModel.productSales.last?.productName ?? "No data",
                                 detail: "Units sold: \(viewModel.productSales.last?.unitsSold ?? 0)")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private var employeeList: some View {
        // The employee shift list
        Section(header: Text("Day shift")) {
            ForEach(viewModel.employees(on: "Day")) { employee in
                Text(employee.fullName)
            }
        }
        Section(header: Text("Evening shift")) {
            ForEach(viewModel.employees(on: "Evening")) { employee in
                Text(employee.fullName)
            }
        }
        Section(header: Text("Night shift")) {
            ForEach(viewModel.employees(on: "Night")) { employee in
                Text(employee.fullName)
            }
        }
    }
    
    var body: some View {
        VStack{
            if dynamicTypeSize.isAccessibilitySize || verticalSizeClass == .compact {
                List {
                    dashboardBoxes
                    employeeList
                }
            } else {
                dashboardBoxes
                List { employeeList }
            }
        }
        .navigationTitle("Dashboard")
        .task {
            await viewModel.loadData()
        }
    }
}

extension DashboardView {
    
    @Observable
    class ViewModel {
        let repository: any DashboardRepositoryProtocol
        
        init(repository: any DashboardRepositoryProtocol) {
            self.repository = repository
        }
        
        var saleState = LoadState.loading
        var bestWorstState = LoadState.loading
        var lowStockState = LoadState.loading
        var shiftState = LoadState.loading
        
        var dailySales: [DailySales] = []
        var lowStock: [ProductStock] = []
        var productSales: [ProductSales] = []
        var shiftEmployees: [ShiftEmployee] = []
            
            // The days the Weekly Sales tile adds up: the last 7 days of sales.
            var lastWeekSales: [DailySales] {
                Array(dailySales.suffix(7))
            }

            var weekTotal: Double {
                var total = 0.0
                for day in lastWeekSales {
                    total += day.totalSales
                }
                return total
            }

            var weekProfit: Double {
                var total = 0.0
                for day in lastWeekSales {
                    total += day.totalProfit
                }
                return total
            }

            // The low stock products, the one furthest below its reorder point first.
            var lowStockByShortfall: [ProductStock] {
                lowStock.sorted { first, second in
                    let firstShortfall = first.reorderPoint - first.stockLevel
                    let secondShortfall = second.reorderPoint - second.stockLevel
                    if firstShortfall == secondShortfall {
                        return first.productName < second.productName
                    }
                    return firstShortfall > secondShortfall
                }
            }

            // The best and the worst seller: the first and last product the API sends.
            var strongPerformer: ProductSales? {
                productSales.first
            }

            var weakPerformer: ProductSales? {
                productSales.last
            }
                
                func employees(on shift: String) -> [ShiftEmployee] {
                    return shiftEmployees.filter { employee in
                        employee.shift == shift
                    }
                }
                
                func loadData() async {
                    async let sales: Void = loadSales()
                    async let bestWorst: Void = loadBestWorst()
                    async let low: Void = loadLowStock()
                    async let shifts: Void = loadShifts()
                    _ = await (sales, bestWorst, low, shifts)
                    
                }
                
                func loadSales() async {
                    saleState = LoadState.loading
                    do {
                        dailySales = try await repository.weeklySales()
                        if dailySales.isEmpty {
                            saleState = LoadState.empty
                        } else {
                            saleState = LoadState.loaded
                        }
                    } catch {
                        saleState = LoadState.failed(message: UserFacingMessage.from(error))
                    }
                }
                
                func loadBestWorst() async {
                    bestWorstState = LoadState.loading
                    do {
                        productSales = try await repository.bestWorst()
                        if productSales.isEmpty {
                            bestWorstState = LoadState.empty
                        } else {
                            bestWorstState = LoadState.loaded
                        }
                    } catch {
                        bestWorstState = LoadState.failed(message: UserFacingMessage.from(error))
                    }
                }
                
                func loadLowStock() async {
                    lowStockState = LoadState.loading
                    do {
                        lowStock = try await repository.lowStock()
                            lowStockState = LoadState.loaded
                    } catch {
                        lowStockState = LoadState.failed(message: UserFacingMessage.from(error))
                    }
                }
                
                func loadShifts() async {
                    shiftState = LoadState.loading
                    do {
                        shiftEmployees = try await repository.shifts()
                        if shiftEmployees.isEmpty {
                            shiftState = LoadState.empty
                        } else {
                            shiftState = LoadState.loaded
                        }
                    } catch {
                        shiftState = LoadState.failed(message: UserFacingMessage.from(error))
                    }
                }
                
                }
}

#Preview {
    NavigationStack {
        DashboardView(repository: RemoteDashboardRepository(urlBase: "https://api.bootcampcentral.com/api", authStatus: AuthStatus()))
    }
}

