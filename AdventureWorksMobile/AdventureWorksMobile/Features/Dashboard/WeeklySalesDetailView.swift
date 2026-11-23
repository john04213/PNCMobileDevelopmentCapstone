//
//  WeeklySalesDetailView.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/22/26.
//

import SwiftUI

// The detail for the Weekly Sales tile: the total sales and profit for the last 7 days,
// then the sales and profit for each of those days.
struct WeeklySalesDetailView: View {

    let viewModel: DashboardView.ViewModel

    private func dollars(_ amount: Double) -> String {
        amount.formatted(.currency(code: "USD"))
    }

    var body: some View {
        VStack {
            switch viewModel.saleState {
            case .loading, .idle:
                LoadingView(message: "Loading sales...")
            case .empty:
                EmptyStateView(message: "No sales found")
            case .failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadSales()
                    }
                })
            case .loaded:
                List {
                    Section(header: Text("Last 7 days")) {
                        Text("Total sales: \(dollars(viewModel.weekTotal))")
                        Text("Total profit: \(dollars(viewModel.weekProfit))")
                    }
                    Section(header: Text("Day by day")) {
                        ForEach(viewModel.lastWeekSales) { day in
                            VStack(alignment: .leading) {
                                Text(day.salesDate.formattedAPIDate)
                                    .bold()
                                Text("Sales: \(dollars(day.totalSales))")
                                Text("Profit: \(dollars(day.totalProfit))")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(day.salesDate.formattedAPIDate), sales \(dollars(day.totalSales)), profit \(dollars(day.totalProfit))")
                        }
                    }
                }
            }
        }
        .navigationTitle("Weekly Sales")
    }
}

#Preview {
    let viewModel = DashboardView.ViewModel(repository: MockDashboardRepository())
    NavigationStack {
        WeeklySalesDetailView(viewModel: viewModel)
            .task {
                await viewModel.loadSales()
            }
    }
}
