//
//  ProductListViewModelTests.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 11/4/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct ProductListViewModelTests{
    private func makeProduct(
        id: Int,
        name: String,
        productNumber: String,
        listPrice: Double
    ) -> ProductElement {
        ProductElement(
            id: id,
            name: name,
            productNumber: productNumber,
            summary: nil ,
            thumbnailPhoto: "",
            thumbnailPhotoFileName: "" ,
            warranty: nil,
            color: "",
            listPrice: listPrice
        )
    }
    
    @Test
    func sortLowToHighOrdersMatchingProducts() {
        let bike = makeProduct(id: 1, name: "Mountain-10k", productNumber: "BK-M12B-45", listPrice: 1200.00)
        let helm = makeProduct(id: 2, name: "Bike Helmet", productNumber: "HELM-R567-89", listPrice: 35.00)
        
        let repo = MockProductRepository()
        let vm = ProductListView.ViewModel(repository: repo)
        vm.products = [bike, helm]
        vm.criteria.sort = .lowToHigh
        
        #expect(vm.matchingProducts.map(\.name) == ["Bike Helmet", "Mountain-10k"])
    }
    
    @Test
    func searchHidingSelectedClearsSelection(){
        let bike = makeProduct(id: 1, name: "Mountain-10k", productNumber: "BK-M12B-45", listPrice: 1200.00)
        let helm = makeProduct(id: 2, name: "Bike Helmet", productNumber: "HELM-R567-89", listPrice: 35.00)
        
        let repo = MockProductRepository()
        let vm = ProductListView.ViewModel(repository: repo)
        vm.products = [bike, helm]
        vm.selectedProduct = bike
        vm.criteria.searchText = "helmet"
        
        #expect(vm.selectedProduct == nil)
    }
    
    @Test
    func tappingTheSelectedProductAgainClosesThePanel() {
        let bike = makeProduct(id: 1, name: "Mountain-10k", productNumber: "BK-M12B-45", listPrice: 1200.00)
        let helm = makeProduct(id: 2, name: "Bike Helmet", productNumber: "HELM-R567-89", listPrice: 35.00)
        
        let repo = MockProductRepository()
        let vm = ProductListView.ViewModel(repository: repo)
        vm.products = [bike, helm]
        vm.toggleSelection(of: bike)
        #expect(vm.selectedProduct == bike)
        vm.toggleSelection(of: bike)
        #expect(vm.selectedProduct == nil)
        
    }
    
    @Test func loadDataPopulatesProductsFromRepository() async {
        // Arrange
        let repo = MockProductRepository()
        let viewModel = ProductListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadProducts()
        
        // Assert
        #expect(viewModel.products.count == 5)
    }
    
    @Test func withBlankFilterMatchingProductsHaveAllProducts() async {
        // Arrange
        let repo = MockProductRepository()
        let viewModel = ProductListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadProducts()
        
        // Assert
        #expect(viewModel.matchingProducts.count == 5)
    }
    
    @Test func withNameFilterMatchingProductsDoesNotHaveAllProducts() async {
        // Arrange
        let repo = MockProductRepository()
        let viewModel = ProductListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadProducts()
        viewModel.criteria.searchText = "Sport-100 Helmet"
        
        // Assert
        #expect(viewModel.matchingProducts.count == 2)
    }
    
    @Test func withProductNumberFilterMatchingProductsDoesNotHaveAllProducts() async {
        // Arrange
        let repo = MockProductRepository()
        let viewModel = ProductListView.ViewModel(repository: repo)
        
        // Act
        await viewModel.loadProducts()
        viewModel.criteria.searchText = "Pr5604-EV454-78"
        
        // Assert
        #expect(viewModel.matchingProducts.count == 1)
    }
}
