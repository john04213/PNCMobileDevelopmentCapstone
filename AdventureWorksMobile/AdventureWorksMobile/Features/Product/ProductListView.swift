//
//  ProductListView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct ProductListView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(repository: any RepositoryProtocol<ProductElement>) {
        viewModel = ViewModel(repository: repository)
    }

    private var filterLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading))
        : AnyLayout(HStackLayout())
    }

    private var rowLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading))
        : AnyLayout(HStackLayout(alignment: .center))
    }

    private var showDetailsOnly: Bool {
        dynamicTypeSize.isAccessibilitySize && viewModel.selectedProduct != nil
    }

    var body: some View {

        VStack {

            LoadingBannerView(
                state: viewModel.state,
                isLoading: viewModel.isLoading,
                refreshErrorMessage: viewModel.refreshErrorMessage,
                itemName: "products"
            )

            switch viewModel.state {
            case .loading, .idle:
                LoadingView(message: "Loading products...")
            case .empty:
                EmptyStateView(message: "No products found")
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
                            "Product Name",
                            text: $viewModel.criteria.searchText
                        )
                        .accessibilityLabel("Filter")
                        .accessibilityHint("Product Name")
                        Picker("Sort", selection: $viewModel.criteria.sort) {
                            ForEach(PriceSort.allCases, id: \.self) { sort in
                                Text(sort.rawValue).tag(sort)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    ActiveFiltersBar(labels: viewModel.criteria.activeLabels,
                                     clearAll: { viewModel.criteria.clear() }
                    )
                    List(viewModel.matchingProducts) { product in
                        rowLayout {
                            Base64GifView(base64String: product.thumbnailPhoto)
                                .frame(width: 100, height: 67)
                                .accessibilityHidden(true)
                            VStack(alignment: .leading) {
                                Text(product.name)
                                Text(
                                    "\(product.productNumber) · \(product.color ?? "NA")"
                                )
                                .foregroundStyle(.primary)
                            }
                        }
                        .onTapGesture {
                            self.viewModel.toggleSelection(of: product)
                            AccessibilityNotification.Announcement(self.viewModel.selectedProduct == nil ? "Product details closed" : "Showing details for \(product.name)").post()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(product.name), product number \(product.productNumber)" + (product.color.map { ", \($0)" } ?? ""))
                        .accessibilityAddTraits(.isButton)
                        .accessibilityAddTraits(viewModel.selectedProduct == product ? .isSelected : [])
                        .accessibilityHint("Shows the product details")

                    }
                    .refreshable {
                        await viewModel.loadProducts()
                    }
                    .overlay {
                        if viewModel.matchingProducts.isEmpty {
                            EmptyStateView(
                                message:
                                    "No products match \"\(viewModel.criteria.searchText)\". Clear the filter to see all products."
                            )
                        }
                    }
                }

                if let selected = viewModel.selectedProduct {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(selected.name)
                                .font(Font.title2)
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Button {
                                viewModel.selectedProduct = nil
                                AccessibilityNotification.Announcement("Product details closed").post()
                            } label : {
                                Image(systemName: "xmark")
                                    .frame(minWidth: 44, minHeight: 44)
                            }
                            .accessibilityLabel("Close")
                            .accessibilityIdentifier("closeSelectedProductButton")
                        }
                        if let summ = selected.summary {
                            ViewThatFits(in: .vertical) {
                                Text(summ)
                                    .font(.caption)
                                    .foregroundStyle(.primary)
                                    .padding(5)
                                ScrollView {
                                    Text(summ)
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                        .padding(5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Products")
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

        var state = LoadState.idle
        var refreshErrorMessage = ""
        private(set) var isLoading = false

        var products: [ProductElement] = [] {
            didSet {
                criteria.clear()
                selectedProduct = nil
            }
        }
        var criteria = ProductCriteria() {
            didSet {
                if let selected = selectedProduct,
                    !matchingProducts.contains(selected)
                {
                    selectedProduct = nil
                }
            }
        }
        var matchingProducts: [ProductElement] {
            criteria.apply(to: products)
        }
        var selectedProduct: ProductElement? = nil
        func toggleSelection(of product: ProductElement) {
            if selectedProduct == product {
                selectedProduct = nil
            } else {
                selectedProduct = product
            }
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
