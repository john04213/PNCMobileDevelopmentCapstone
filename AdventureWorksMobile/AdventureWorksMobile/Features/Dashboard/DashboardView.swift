//
//  DashboardView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var viewModel: ViewModel
    
    init(repository: any DashboardRepositoryProtocol) {
        viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        VStack {
            // Tapping funcinality needs to be added to the boxes
            
            VStack {
                HStack {
                    NavigationLink {
                        // add link to weekly sales
                    } label: {
                        DashboardBox(title: "Weekly Sales",
                                     systemImage: "dollarsign.circle",
                                     color: .gray,
                                     value: viewModel.weekTotal.formatted(.currency(code: "USD")),
                                     detail: "Last 7 days")
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        // ad dlink to low stock
                    } label: {
                        DashboardBox(title: "Low Stock",
                                     systemImage: "shippingbox",
                                     color: .gray,
                                     value: "\(viewModel.lowStock.count)",
                                     detail: "Products to reorder")
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    NavigationLink {
                        // add link to strong performer
                    } label: {
                        DashboardBox(title: "Strong Performer",
                                     systemImage: "chart.line.uptrend.xyaxis",
                                     color: .gray,
                                     value: viewModel.productSales.first?.productName ?? "No data",
                                     detail: "Units sold: \(viewModel.productSales.first?.unitsSold ?? 0)")
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        // add link to weak performers
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
            .padding()
            
            // The employee shift list
            List {
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
            
            var weekTotal: Double {
                var total = 0.0
                for day in dailySales.suffix(7) {
                    total += day.totalSales
                }
                return total
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

