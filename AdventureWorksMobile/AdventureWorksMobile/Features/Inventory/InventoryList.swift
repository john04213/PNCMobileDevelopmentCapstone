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
        
        
        VStack(spacing: 0) {
            
            // Reusable banner component that displays refresh loading state
            LoadingStateView(state: viewModel.loadingState)
            
            //Reusable wrapper view that displays content based on the current loading state.
            LoadableView(
                state: viewModel.loadingState,
                retry: {
                    Task {
                        await viewModel.loadProducts()
                    }
                }
            ) {
                VStack {
                    
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
                    .refreshable {
                        await viewModel.loadProducts(isRefresh: true)
                    }
                }
            }
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

extension InventoryList {
    
    @Observable
    class ViewModel {
        
        let repository: any RepositoryProtocol<InventoryElement>
        
        var loadingState: LoadingState = .loading
        
        
        init(repository: any RepositoryProtocol<InventoryElement>) {
            self.repository = repository
        }
        
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
        
        
        func loadProducts(isRefresh: Bool = false) async {
            
            loadingState = (isRefresh) ? .refreshing : .loading
            
            do {
                
                products = try await repository.getAll()
                loadingState = (products.isEmpty) ? .empty : .success
                
            } catch {
                
                if (isRefresh && !products.isEmpty) {
                    loadingState = .refreshFailure("Couldn't refresh. Showing existing data.")
                } else {
                    loadingState = .failure(error.localizedDescription)
                }
                
            }
        }
    }
}
