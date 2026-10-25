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
            switch viewModel.state {
            case .loading, .idle :
                LoadingView(message:"Loading inventory...")
            case .empty:
                EmptyStateView(message:"No inventory found")
            case.failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadProducts()
                    }
                })
            case .loaded:
                if !viewModel.refreshErrorMessage.isEmpty {
                    Label(viewModel.refreshErrorMessage, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
                HStack {
                    Text("Filter")
                    TextField("Product Name or Location", text: $viewModel.filter)
                }
                .padding()
                List(viewModel.matchingProducts) { product in
                    HStack (alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(product.productName)
                                .lineLimit(1)
                            Text("\(product.locationName) · Shelf \(product.shelf) · Bin \(product.bin)")
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(product.quantity)")
                    }
                }
                .refreshable{
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
        private var isLoading = false
        
        var products: [InventoryElement] = [] {
            didSet {
                filter = ""
            }
        }
        var filter: String = "" {
            didSet {
                matchingProducts = products.filter { product in
                    filter == "" ||
                    product.productName.lowercased()
                        .contains(filter.lowercased()) ||
                    product.locationName.lowercased()
                        .contains(filter.lowercased())
                }
            }
        }
        var matchingProducts: [InventoryElement] = []
        
        func loadProducts() async {
           guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            refreshErrorMessage = ""
            if products.isEmpty {state = LoadState.loading}
            do {
                products = try await repository.getAll()
                if(products.isEmpty) {state = .empty
                } else {
                    state = LoadState.loaded
                }
            } catch {
                let message = UserFacingMessage.from(error)
                if(products.isEmpty) {state = LoadState.failed(message: message)
                } else {
                    refreshErrorMessage = message
                }
            }
        }
    }
}

