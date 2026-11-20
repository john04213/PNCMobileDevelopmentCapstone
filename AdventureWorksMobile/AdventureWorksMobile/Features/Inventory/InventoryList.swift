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
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    init(repository: any RepositoryProtocol<InventoryElement>) {
        viewModel = ViewModel(repository: repository)
    }

    private var filterLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading))
        : AnyLayout(HStackLayout())
    }

    private var popupButtonLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout())
        : AnyLayout(HStackLayout())
    }

    private var showDetailsOnly: Bool {
        dynamicTypeSize.isAccessibilitySize && viewModel.selectedProduct != nil
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
                    if !showDetailsOnly {
                        filterLayout {
                            Text("Filter")
                                .accessibilityHidden(true)
                            TextField(
                                "Product Name or Location",
                                text: $viewModel.criteria.searchText
                            )
                            .accessibilityLabel("Filter")
                            .accessibilityHint("Product Name or Location")
                        }
                        .padding()
                        ActiveFiltersBar(
                            labels: viewModel.activeLabels,
                            clearAll: { viewModel.clearFilters() }
                        )
                        List(viewModel.matchingProducts) { product in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text(product.productName)
                                    Text(
                                        "\(product.locationName) · Shelf \(product.shelf) · Bin \(product.bin)"
                                    )
                                    .foregroundStyle(.primary)
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
                                AccessibilityNotification.Announcement("Adjusting quantity for \(product.productName). Current quantity \(product.quantity).").post()
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(product.productName), \(product.locationName), shelf \(product.shelf), bin \(product.bin), quantity \(product.quantity)" + (viewModel.isLowStock(product: product) ? ", low stock, reorder at \(product.reorderPoint)" : ""))
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Opens quantity adjustment")
                        }
                        .refreshable {
                            await viewModel.loadProducts()
                        }
                        .overlay{
                            if viewModel.matchingProducts.isEmpty{
                                EmptyStateView(message:"No matching inventory. Tap clear all to see everything" )
                            }
                        }
                    }
                    if let selected = viewModel.selectedProduct {
                            VStack {
                                HStack {
                                    Button(action: {
                                        count = 0
                                        viewModel.selectedProduct = nil
                                        AccessibilityNotification.Announcement("Adjustment cancelled").post()
                                    }) {
                                        Text("Cancel")
                                            .foregroundStyle(.blue)
                                    }
                                    Spacer()
                                    Text("Adjust quantity")
                                        .bold()
                                        .accessibilityAddTraits(.isHeader)
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            showPopup = true
                                        }
                                        AccessibilityNotification.Announcement("Are you sure? This will update the stock of the specified inventory item.").post()
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
                                                confirmUpdate = false
                                                
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
                                
                                ScrollView{
                                    Text(selected.productName)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    Text("\(selected.locationName) · Shelf \(selected.shelf) · Bin \(selected.bin)")
                                        .foregroundStyle(.primary)
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
                                            AccessibilityNotification.Announcement("New quantity \(count)").post()
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .font(.largeTitle)
                                                .foregroundStyle(.gray)
                                                .accessibilityLabel("Decrease quantity")
                                        }
                                        Spacer()
                                        Text("\(count)")
                                            .font(.largeTitle.bold())
                                            .frame(minWidth: 60)
                                        Spacer()
                                        Button(action: {
                                            count += 1
                                            AccessibilityNotification.Announcement("New quantity \(count)").post()
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .font(.largeTitle)
                                                .foregroundStyle(.gray)
                                                .accessibilityLabel("Increase quantity")
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
                                            Text("Change \(count - selected.quantity)")
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
                
            }
            .navigationTitle("Inventory")
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
                        .foregroundColor(.primary)
                    popupButtonLayout {
                        Button("No") {
                            withAnimation {
                                showPopup = false
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.70, green: 0.10, blue: 0.10))
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
                        .background(Color(red: 0.0, green: 0.45, blue: 0.20))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(24)
                .background(.background)
                .cornerRadius(16)
                .shadow(radius: 20)
                .frame(maxWidth: 300)
                .transition(.scale.combined(with: .opacity))
                .accessibilityAddTraits(.isModal)
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
                criteria.clear()
                generateDictionary()
                generateLowStockList()
                
            }
        }
        var criteria = InventoryCriteria()
        
        
        var matchingProducts: [InventoryElement] {
            
            let selectedProducts = showLowStock ? lowStockProducts : products
            
            return criteria.apply(to: selectedProducts)
            
        }
        var activeLabels: [String] {
            var labels = criteria.activeLabels
            if showLowStock{
                labels.append("Low stock")
            }
            return labels
        }
        func clearFilters() {
            criteria.clear()
            showLowStock = false
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
