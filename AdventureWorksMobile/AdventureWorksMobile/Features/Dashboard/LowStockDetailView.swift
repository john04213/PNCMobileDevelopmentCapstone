//
//  LowStockDetailView.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/22/26.
//

import SwiftUI

// The detail for the Low Stock tile: every product to reorder, the one furthest below its reorder point first.
struct LowStockDetailView: View {

    let viewModel: DashboardView.ViewModel

    var body: some View {
        VStack {
            switch viewModel.lowStockState {
            case .loading, .idle:
                LoadingView(message: "Loading low stock...")
            case .empty:
                EmptyStateView(message: "No products need reordering")
            case .failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadLowStock()
                    }
                })
            case .loaded:
                if viewModel.lowStock.isEmpty {
                    EmptyStateView(message: "No products need reordering")
                } else {
                    List {
                        Section(header: Text("Products to reorder: \(viewModel.lowStock.count)")) {
                            ForEach(viewModel.lowStockByShortfall) { product in
                                VStack(alignment: .leading) {
                                    Text(product.productName)
                                        .bold()
                                    Text(product.statusText)
                                    Text("In stock: \(product.stockLevel) · Reorder at: \(product.reorderPoint)")
                                        .font(.caption)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(product.productName), \(product.statusText), \(product.stockLevel) in stock, reorder at \(product.reorderPoint)")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Low Stock")
    }
}

extension ProductStock {

    // How low this product is in words, so it is never shown by color alone.
    var statusText: String {
        if stockLevel <= 0 {
            return "Out of stock"
        }
        if stockLevel < reorderPoint {
            return "Below reorder point"
        }
        return "At reorder point"
    }
}

#Preview {
    let viewModel = DashboardView.ViewModel(repository: MockDashboardRepository())
    NavigationStack {
        LowStockDetailView(viewModel: viewModel)
            .task {
                await viewModel.loadLowStock()
            }
    }
}
