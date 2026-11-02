//
//  InventoryListViewModelTests.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/19/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct InventoryListViewModelTests{
    
    @Test
    func failureShowsFriendlyErrorState() async{
        //Arrange
        let repo = FailingInventoryRepository()
        let vm = InventoryList.ViewModel(repository: repo)
       
        // act
        await vm.loadProducts()
        
        //assert
        if case .failed(let errorMessage) = vm.state {
            #expect(!errorMessage.contains("URLError"))
        } else {
            Issue.record("expected failed state")
        }
        
    }
    
    @Test
    func retryAfterFailureLoads() async {
        let repo = FailingInventoryRepository()
        let vm = InventoryList.ViewModel(repository: repo)
    
        await vm.loadProducts()
        repo.shouldFail = false
        repo.itemsToReturn = [InventoryElement(
            productId: 1,
            productName: "Adjustable Race",
            productNumber: "AR-5381",
            safetyStockLevel: 1000,
            reorderPoint: 750,
            locationId: 1,
            locationName: "Tool Crib",
            shelf: "A",
            bin: 1,
            quantity: 195
        )]
        await vm.loadProducts()
        
        #expect(vm.state == .loaded)
    }
    
    @Test
    func emptyResultShowsEmptyState() async {
        let repo = FailingInventoryRepository()
        repo.shouldFail = false
        let vm = InventoryList.ViewModel(repository: repo)
        
        await vm.loadProducts()
        
        #expect(vm.state == .empty)
    }
    
    @Test
    func refreshFailureKeepsOldData() async {
        let repo = FailingInventoryRepository()
        repo.shouldFail = false
        repo.itemsToReturn = [InventoryElement(
            productId: 1,
            productName: "Adjustable Race",
            productNumber: "AR-5381",
            safetyStockLevel: 1000,
            reorderPoint: 750,
            locationId: 1,
            locationName: "Tool Crib",
            shelf: "A",
            bin: 1,
            quantity: 195
        )]
        
        let vm = InventoryList.ViewModel(repository: repo)
        await vm.loadProducts()
        repo.shouldFail = true
        await vm.loadProducts()
        
        #expect(vm.state == .loaded)
        #expect(!vm.refreshErrorMessage.isEmpty)
        #expect(vm.products.count == 1)
    }
    
    @Test
    func spinnerNeverStuck() async {
        let repo = FailingInventoryRepository()
        let vm = InventoryList.ViewModel(repository: repo)
        
        
        await vm.loadProducts()
        
        #expect(vm.state != .loading)
    }
    
    @Test
    func lowStockChipAddsLabel() {
        let repo = FailingInventoryRepository()
        let vm = InventoryList.ViewModel(repository: repo)
        vm.criteria.searchText = "race"
        vm.showLowStock = true
        
        let labels = vm.activeLabels
        
        #expect(labels == ["Search: \"race\"", "Low stock" ])
        
    }
    
    @Test
    func clearFiltersResetsBoth() {
        let repo = FailingInventoryRepository()
        let vm = InventoryList.ViewModel(repository: repo)
        vm.criteria.searchText = "race"
        vm.showLowStock = true
        
        vm.clearFilters()
        
        #expect(vm.criteria.searchText.isEmpty)
        #expect(!vm.showLowStock)
        #expect(vm.activeLabels.isEmpty)
    }
}
