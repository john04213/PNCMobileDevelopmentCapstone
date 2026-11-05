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
}
