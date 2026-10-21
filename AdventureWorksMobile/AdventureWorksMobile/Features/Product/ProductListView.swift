//
//  ProductListView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct ProductListView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<ProductElement>) {
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
                        TextField("Product Name", text: $viewModel.filter)
                    }
                    .padding()
                    List(viewModel.matchingProducts) { product in
                        HStack(alignment: .center) {
                            Base64GifView(base64String: product.thumbnailPhoto)
                                .frame(width: 100, height: 67)
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .lineLimit(1)
                                Text("\(product.productNumber) · \(product.color ?? "NA")")
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onTapGesture {
                            self.viewModel.selectedProduct = product
                        }
                    }
                    .refreshable {
                        await viewModel.loadProducts(isRefresh: true)
                    }
                    if let selected = viewModel.selectedProduct {
                        VStack(alignment: .leading) {
                            Text(selected.name)
                                .font(Font.title2)
                            if let summ = selected.summary {
                                Text(summ)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(5)
                            }
                        }
                    }
                    
                }
            }
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

extension ProductListView {
    
    @Observable
    class ViewModel {
        
        let repository: any RepositoryProtocol<ProductElement>
        
        var loadingState: LoadingState = .loading
        
        init(repository: any RepositoryProtocol<ProductElement>) {
            self.repository = repository
        }
        
        var products: [ProductElement] = [] {
            didSet {
                filter = ""
                selectedProduct = nil
            }
        }
        var filter: String = "" {
            didSet {
                matchingProducts = products.filter { product in
                    filter == "" ||
                    product.name.lowercased()
                        .contains(filter.lowercased()) ||
                    product.productNumber.lowercased()
                        .contains(filter.lowercased())
                }
            }
        }
        var matchingProducts: [ProductElement] = [] {
            didSet {
                if let selected = selectedProduct,
                   !matchingProducts.contains(selected) {
                    selectedProduct = nil
                }
            }
        }
        var selectedProduct: ProductElement? = nil
        
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
