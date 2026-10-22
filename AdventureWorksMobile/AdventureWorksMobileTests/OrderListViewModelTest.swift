//
//  OrderListViewModelTest.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/22/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct OrderListViewModelTest {
    @Test func loadDataPopulatesOrdersFromRepository() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        
        // Assert
        #expect(viewModel.orders.count == 2)
    }
    
    @Test func orderWithMultipleLineItemsCalculateQuantityCorrectly() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        
        // Assert
        #expect(viewModel.quantity(order: viewModel.orders[0]) == 2)
    }
    
    @Test func ordersWithMultipleLineItemsGivePluralReference() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        
        // Assert
        #expect(viewModel.plural(order: viewModel.orders[0]) == "s")
    }
    
    @Test func totalPriceAddsTheQuantitiesFromLineItems() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        
        // Assert
        #expect(viewModel.totalPrice(order: viewModel.orders[0]) == (356.898000 + 356.898000))
    }
    
    @Test func withBlankFilterMatchingOrdersHasAllOrders() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        
        // Assert
        #expect(viewModel.matchingOrders.count == 2)
    }
    
    @Test func withNameFilterMatchingOrdersDoesNotHaveAllOrders() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        viewModel.filter = "SO71774"
        
        // Assert
        #expect(viewModel.matchingOrders.count == 1)
    }
    
    @Test func withStoreNameFilterMatchingOrdersDoesNotHaveAllOrders() async {
        // Arrange
        let repo = MockOrderRepository()
        let viewModel = OrderListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadOrders()
        viewModel.filter = "Good Toys"
        
        // Assert
        #expect(viewModel.matchingOrders.count == 1)
    }
}
