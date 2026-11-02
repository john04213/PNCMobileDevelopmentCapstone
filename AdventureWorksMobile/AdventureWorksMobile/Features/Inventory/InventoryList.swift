//
//  InventoryList.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import SwiftUI

struct InventoryList: View {
    @State private var viewModel: ViewModel
    @State private var count: Int = 0
    @State private var showPopup = false
    @State private var confirmUpdate = false

    init(repository: any RepositoryProtocol<InventoryElement>) {
        viewModel = ViewModel(repository: repository)
    }

    var body: some View {
        ZStack {
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
                        .onTapGesture {
                            self.viewModel.selectedProduct = product
                            count = product.quantity
                        }
                    }
                    .refreshable {
                        await viewModel.loadProducts()
                    }
                    if let selected = viewModel.selectedProduct {
                        VStack {
                            HStack {
                                Button(action: {
                                    count = 0
                                    viewModel.selectedProduct = nil
                                }) {
                                    Text("Cancel")
                                        .foregroundStyle(.blue)
                                }
                                Spacer()
                                Text("Adjust quantity")
                                    .bold()
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        showPopup = true
                                    }
                                    Task {
                                        await viewModel.waitForFalse { self.showPopup }
                                        if confirmUpdate {
                                            let invItem = InventoryElement(
                                                productId: selected.productId,
                                                productName: selected.productName,
                                                productNumber: selected.productNumber,
                                                safetyStockLevel: selected.safetyStockLevel,
                                                reorderPoint: selected.reorderPoint,
                                                locationId: selected.locationId,
                                                locationName: selected.locationName,
                                                shelf: selected.shelf,
                                                bin: selected.bin,
                                                quantity: count
                                            )
                                            await viewModel.updateProduct(item: invItem)
                                            await viewModel.loadProducts()
                                            
                                            count = 0
                                            viewModel.selectedProduct = nil
                                        }
                                    }
                                }) {
                                    Text("Save")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            Text(selected.productName)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Text("\(selected.locationName) · Shelf \(selected.shelf) · Bin \(selected.bin)")
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            Text("New quantity")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            HStack {
                                Button(action: {
                                    count > 0 ? count -= 1 : ()
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Text("\(count)")
                                    .font(.system(size: 60, weight: .bold))
                                    .frame(minWidth: 60)
                                Spacer()
                                Button(action: {
                                    count += 1
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.gray)
                                }
                            }
                                .padding(.horizontal)
                            Divider()
                            HStack {
                                Text("Current quantity")
                                Spacer()
                                Text(String(selected.quantity))
                                    .bold()
                            }
                                .padding(.horizontal)
                            Divider()
                            HStack {
                                Text("Change")
                                Spacer()
                                if selected.quantity != count {
                                    Text("Change")
                                        .bold()
                                }
                                else {
                                    Text("No change")
                                        .bold()
                                }
                            }
                                .padding(.horizontal)
                        }
                    }
                }
                
            }
            .task {
                await viewModel.loadProducts()
            }
            if showPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation { showPopup = false }
                    }
                VStack(spacing: 20) {
                    Text("Are you sure?")
                        .font(.headline)
                        .bold()
                    Text("This will update the stock of the specified inventory item.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    HStack {
                        Button("No") {
                            withAnimation {
                                
                                showPopup = false
                            }
                        }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        Button("Yes") {
                            withAnimation {
                                confirmUpdate = true
                                showPopup = false
                            }
                        }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                    .padding(24)
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .frame(width: 300)
                    .transition(.scale.combined(with: .opacity))
            }
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
        var selectedProduct: InventoryElement? = nil
        
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
        
        func updateProduct(item: InventoryElement) async {
            refreshErrorMessage = ""
            do {
                try await repository.update(item)
            } catch {
                refreshErrorMessage = UserFacingMessage.from(error)
            }
        }
        
        func waitForFalse(condition: @escaping () -> Bool) async {
            while condition() {
                try? await Task.sleep(for: .milliseconds(50))
            }
        }
    }
}
