//
//  OrderListView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct OrderListView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<OrderElement>) {
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
                TextField("Order number or store", text: $viewModel.filter)
            }
            .padding()
            List(viewModel.matchingOrders) { order in
                HStack (alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(order.name)
                            .bold()
                            .lineLimit(1)
                        Text("\(order.storeName) · \(viewModel.quantity(order: order)) item\(viewModel.plural(order: order))" )
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text("\(String(format: "$%.2f", viewModel.totalPrice(order: order)))")
                            .bold()
                            .lineLimit(1)
                        Text("[\(order.orderDate.replacingOccurrences(of: "T00:00:00", with: ""))]")
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                    }
                }
                .onTapGesture {
                    self.viewModel.selectedOrder = order
                }
            }
            if let selected = viewModel.selectedOrder {
                VStack(alignment: .center) {
                    Text(selected.name)
                        .font(Font.title2)
                        .bold()
                    Text("\(selected.storeName) · \(viewModel.quantity(order: selected)) item\(viewModel.plural(order: selected))" )
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 20)
                    List() {
                        ForEach(selected.lineItems) { lineItem in
                            UniqueBlockView(title: lineItem.productName, subTitle: "\(lineItem.orderQty) x \(String(format: "$%.2f", lineItem.unitPrice))", total: lineItem.lineTotal)
                        }
                        UniqueBlockView(title: "Order total", total: viewModel.totalPrice(order: selected))
                    }
                }
            }
        }
        .task {
            await viewModel.loadOrders()
        }
    }
}

extension OrderListView {
    
    @Observable
    class ViewModel {
        
        let repository: any RepositoryProtocol<OrderElement>
        
        init(repository: any RepositoryProtocol<OrderElement>) {
            self.repository = repository
        }
        
        var errorMessage = ""
        
        var orders: [Order] = [] {
            didSet {
                filter = ""
            }
        }
        var filter: String = "" {
            didSet {
                matchingOrders = orders.filter { order in
                    filter == "" ||
                    order.name.lowercased()
                        .contains(filter.lowercased()) ||
                    order.storeName.lowercased()
                        .contains(filter.lowercased())
                }
            }
        }
        var matchingOrders: [Order] = [] {
            didSet {
                if let selected = selectedOrder,
                   !matchingOrders.contains(selected) {
                    selectedOrder = nil
                }
            }
        }
        var selectedOrder: Order? = nil
        
        func loadOrders() async {
            errorMessage = ""
            do {
                let tempOrders = try await repository.getAll()
                orders = convertAllOrders(orders: tempOrders)
            } catch {
                errorMessage = "\(error)"
            }
        }
        
        func plural(order: Order) -> String {
            let quantity = quantity(order: order)
            let output: String = quantity == 1 ? "" : "s"
            return output
        }
        
        func quantity(order: Order) -> Int {
            var quantity = 0
            order.lineItems.forEach { lineItem in
                quantity += lineItem.orderQty
            }
            return quantity
        }
        
        func totalPrice(order:  Order) -> Double {
            var total = 0.0
            order.lineItems.forEach { lineItem in
                total += lineItem.lineTotal
            }
            return total
        }
    }
}
