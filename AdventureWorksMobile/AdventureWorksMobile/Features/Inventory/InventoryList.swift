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
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .font(Font.title)
                    .background(Color.red.opacity(0.1))
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
        
        var errorMessage = ""
        
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
            errorMessage = ""
            do {
                products = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}
