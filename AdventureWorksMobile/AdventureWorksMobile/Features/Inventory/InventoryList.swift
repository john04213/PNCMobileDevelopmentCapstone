//
//  InventoryList.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import SwiftUI

struct InventoryList: View {
    @State private var viewModel: ViewModel
    
    init(repository1: any RepositoryProtocol<ProductElement>, repository2: any RepositoryProtocol<InventoryElement>) {
        viewModel = ViewModel(repository1: repository1, repository2: repository2)
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
                Image(systemName: "arrow.clockwise")
                    .frame(width: 20, height: 20)
            }
            .padding()
            List(viewModel.matchingProducts) { product in
                HStack(alignment: .center) {
                    Base64GifView(base64String: product.thumbnailPhoto)
                        .frame(width: 100, height: 67)
                    VStack(alignment: .leading) {
                        Text("\(product.id) - \(product.name)")
                            .lineLimit(1)
                        if let summ = product.summary {
                            Text(summ)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("...")
                        }
                        HStack {
                            Text("Price:")
                            Text(String(format: "$%.2f", product.listPrice))
                        }
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

extension InventoryList {
    
    @Observable
    class ViewModel {
        
        let repository1: any RepositoryProtocol<ProductElement>
        let repository2: any RepositoryProtocol<InventoryElement>
        
        init(repository1: any RepositoryProtocol<ProductElement>, repository2: any RepositoryProtocol<InventoryElement>) {
            self.repository1 = repository1
            self.repository2 = repository2
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
                products = try await repository1.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}
