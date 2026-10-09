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
        VStack {
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .font(Font.title)
                    .background(Color.red.opacity(0.1))
            }
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
        .task {
            await viewModel.loadProducts()
        }
    }
}

extension ProductListView {
    
    @Observable
    class ViewModel {
        
        let repository: any RepositoryProtocol<ProductElement>
        
        init(repository: any RepositoryProtocol<ProductElement>) {
            self.repository = repository
        }
        
        var errorMessage = ""
        
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
        
        func loadProducts() async {
            errorMessage = ""
            do {
                products = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}
