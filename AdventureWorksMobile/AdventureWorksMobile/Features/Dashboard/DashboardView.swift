//
//  DashboardView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct DashboardView: View {

    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
            }

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

        var dailySales: [DailySales] = []
        var lowStock: [ProductStock] = []
        var productSales: [ProductSales] = []
        var shiftEmployees: [ShiftEmployee] = []
        var errorMessage = ""

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
            do {
                dailySales = try await getList("weekly-sales")
                lowStock = try await getList("low-stock")
                productSales = try await getList("best-worst")
                shiftEmployees = try await getList("shifts")
            }
            catch {
                errorMessage = "Could not load the dashboard."
            }
        }

        // Downloads one list from the API and turns the JSON into an array.
        func getList<T: Decodable>(_ endpoint: String) async throws -> [T] {
            let url = URL(string: "https://api.bootcampcentral.com/api/Dashboard/\(endpoint)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([T].self, from: data)
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}

