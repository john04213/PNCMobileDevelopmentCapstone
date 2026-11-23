//
//  ProductPerformanceDetailView.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/22/26.
//

import SwiftUI

// The detail for the Strong Performer and Weak Performer tiles: that product's sales and stock.
// Both tiles use this one screen, they only pass a different title, summary, and product.
struct ProductPerformanceDetailView: View {

    let viewModel: DashboardView.ViewModel
    let title: String
    let summary: String
    let isStrong: Bool

    private var product: ProductSales? {
        isStrong ? viewModel.strongPerformer : viewModel.weakPerformer
    }

    var body: some View {
        VStack {
            switch viewModel.bestWorstState {
            case .loading, .idle:
                LoadingView(message: "Loading product sales...")
            case .empty:
                EmptyStateView(message: "No product sales found")
            case .failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadBestWorst()
                    }
                })
            case .loaded:
                if let product {
                    List {
                        Section(header: Text(summary)) {
                            Text("Name: \(product.productName)")
                            Text("Product ID: \(product.productId)")
                        }
                        Section(header: Text("Sales and stock")) {
                            Text("Units sold: \(product.unitsSold)")
                            Text("Units in stock: \(product.unitsInStock)")
                        }
                    }
                } else {
                    EmptyStateView(message: "No product sales found")
                }
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    let viewModel = DashboardView.ViewModel(repository: MockDashboardRepository())
    NavigationStack {
        ProductPerformanceDetailView(viewModel: viewModel,
                                     title: "Strong Performer",
                                     summary: "Selling well",
                                     isStrong: true)
            .task {
                await viewModel.loadBestWorst()
            }
    }
}
