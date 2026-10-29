//
//  InventoryList.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import SwiftUI

struct InventoryList: View {
    @State private var viewModel: ViewModel

    init(repository: any RepositoryProtocol<InventoryElement>) {
        viewModel = ViewModel(repository: repository)
    }

    var body: some View {
        VStack {
            
            LoadingBannerView(
                state: viewModel.state,
                isLoading: viewModel.isLoading,
                refreshErrorMessage: viewModel.refreshErrorMessage,
                itemName: "inventory"
            )
            Picker("Inventory Filter", selection: $viewModel.showLowStock) {
                Text("All").tag(false)
                Text("Low stock (\(viewModel.lowStockCount))").tag(true)
            }
            .pickerStyle(.segmented)
            
            switch viewModel.state {
            case .loading, .idle:
                LoadingView(message: "Loading inventory...")
            case .empty:
                EmptyStateView(message: "No inventory found")
            case .failed(let errorMessage):
                ErrorStateView(
                    message: errorMessage,
                    retryAction: {
                        Task {
                            await viewModel.loadProducts()
                        }
                    }
                )
            case .loaded:
                if !viewModel.refreshErrorMessage.isEmpty {
                    Label(
                        viewModel.refreshErrorMessage,
                        systemImage: "exclamationmark.triangle"
                    )
                    .foregroundStyle(.red)
                }
                HStack {
                    Text("Filter")
                    TextField(
                        "Product Name or Location",
                        text: $viewModel.filter
                    )
                }
                .padding()
                List(viewModel.matchingProducts) { product in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(product.productName)
                                .lineLimit(1)
                            Text(
                                "\(product.locationName) · Shelf \(product.shelf) · Bin \(product.bin)"
                            )
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                            if viewModel.isLowStock(product: product) {
                                HStack {
                                    Image(
                                        systemName: "exclamationmark.triangle"
                                    )
                                    .foregroundColor(.brown)
                                    Text(
                                        "Low stock · Reorder at \(product.reorderPoint)"
                                    )

                                }
                            }
                        }
                        Spacer()
                        Text("\(product.quantity)")
                    }
                }
                .refreshable {
                    await viewModel.loadProducts()
                }
            }

        }
        .task {
            await viewModel.loadProducts()
        }
    }
}

extension InventoryList {

    @Observable
    class ViewModel {

        let repository: any RepositoryProtocol<InventoryElement>

        init(repository: any RepositoryProtocol<InventoryElement>) {
            self.repository = repository
        }
        var state = LoadState.idle
        
        var refreshErrorMessage = ""
        private(set) var isLoading = false
        
        var showLowStock = false
        
        var totalQuantityByProductNumber: [String: Int] = [:]

        var products: [InventoryElement] = [] {
            didSet {
                filter = ""
                generateDictionary()
                generateLowStockList()

            }
        }
        var filter: String = ""
        
        var matchingProducts: [InventoryElement] {
            
            let selectedProducts = showLowStock ? lowStockProducts : products
            
            return selectedProducts.filter { product in
               filter == ""
                   || product.productName.lowercased()
                       .contains(filter.lowercased())
                   || product.locationName.lowercased()
                       .contains(filter.lowercased())
           }
            
        }
        
        var lowStockProducts: [InventoryElement] = []
        
        var lowStockCount: Int {
            Set(lowStockProducts.map(\.productNumber)).count
        }

        func generateDictionary() {
            
            totalQuantityByProductNumber = [:]
            
            products.forEach { product in
                if let quantity = totalQuantityByProductNumber[product.productNumber] {
                    totalQuantityByProductNumber[product.productNumber] =
                        quantity + product.quantity
                } else {
                    totalQuantityByProductNumber[product.productNumber] =
                        product.quantity
                }
            }
        }
        
        func generateLowStockList() {
            lowStockProducts = products.filter { product in
                isLowStock(product: product)
            }
        }

        func isLowStock(product: InventoryElement) -> Bool {
            guard let totalQuantity = totalQuantityByProductNumber[product.productNumber] else {
                return false
            }
            return totalQuantity <= product.safetyStockLevel
        }

        func loadProducts() async {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            refreshErrorMessage = ""
            if products.isEmpty { state = LoadState.loading }
            do {
                products = try await repository.getAll()
                if products.isEmpty {
                    state = .empty
                } else {
                    state = LoadState.loaded
                }
            } catch {
                let message = UserFacingMessage.from(error)
                if products.isEmpty {
                    state = LoadState.failed(message: message)
                } else {
                    refreshErrorMessage = message
                }
            }
        }
    }
}
