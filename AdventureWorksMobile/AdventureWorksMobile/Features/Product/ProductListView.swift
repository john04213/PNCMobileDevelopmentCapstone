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
                HStack {
                    Text("Filter")
                    TextField(
                        "Product Name",
                        text: $viewModel.criteria.searchText
                    )
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
                    HStack(alignment: .center) {
                        Base64GifView(base64String: product.thumbnailPhoto)
                            .frame(width: 100, height: 67)
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .lineLimit(1)
                            Text(
                                "\(product.productNumber) · \(product.color ?? "NA")"
                            )
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .onTapGesture {
                        self.viewModel.toggleSelection(of: product)
                    }

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

                if let selected = viewModel.selectedProduct {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(selected.name)
                                .font(Font.title2)
                            Spacer()
                            Button {
                                viewModel.selectedProduct = nil
                            } label : {
                                Image(systemName: "xmark")
                                    .frame(minWidth: 44, minHeight: 44)
                            }
                            .accessibilityLabel("Close")
                            .accessibilityIdentifier("closeSelectedProductButton")
                        }
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
