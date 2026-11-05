//
//  ProductCriteriaTest.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/27/26.
//

import Testing
@testable import AdventureWorksMobile
@MainActor
struct ProductCriteriaTest{
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
    // bike-- finds the bike by its product number that takes in 2 products and returns back only the bike
    @Test
    func searchMatchesProductNumber()  {
        let bike = makeProduct(id: 1, name: "Mountain-10k", productNumber: "BK-M12B-45", listPrice: 1200.00)
        let frame = makeProduct(id: 2, name: "Mountain Frame", productNumber: "FRAME-R567-89", listPrice: 800.00)
        
        var criteria = ProductCriteria()
        criteria.searchText = "bk-"
        
        let result = criteria.apply(to: [bike, frame])
        #expect(result.map(\.name) == ["Mountain-10k"])
    }
    // sort low to high based on prices cheapest first
    @Test
    func lowToHighSortsByPrice() {
        let expensive = makeProduct(id: 1, name: "Expensive", productNumber: "X-1", listPrice: 10.00)
        let cheap = makeProduct(id: 2, name: "Cheap", productNumber: "X-2", listPrice: 2.00)
        let affordable = makeProduct(id: 3, name: "Affordable", productNumber: "X-3", listPrice: 5.00)
        
        
        var criteria = ProductCriteria()
        criteria.sort = .lowToHigh
        
        let result = criteria.apply(to: [expensive, cheap, affordable])
        #expect(result.map(\.listPrice) == [2.00, 5.00, 10.00])
    }
    
    // sort high to low based on prices
    @Test
    func highToLowSortsByPrice() {
        let expensive = makeProduct(id: 1, name: "Expensive", productNumber: "X-1", listPrice: 10.00)
        let cheap = makeProduct(id: 2, name: "Cheap", productNumber: "X-3", listPrice: 2.00)
        let affordable = makeProduct(id: 3, name: "Affordable", productNumber: "X-2", listPrice: 5.00)
        
        var criteria =  ProductCriteria()
        criteria.sort = .highToLow
        
        let result = criteria.apply(to: [expensive, cheap, affordable])
        #expect(result.map(\.listPrice) == [10.00, 5.00, 2.00])
    }
    
    // if prices are the same, sorted by name in alphabetical order
    @Test
    func equalPricesSortByName(){
        let b = makeProduct(id: 1, name: "B", productNumber: "X-1", listPrice: 10.00)
        let a = makeProduct(id: 2, name: "A", productNumber: "X-2", listPrice: 10.00)
        
        var criteria = ProductCriteria()
        criteria.sort = .lowToHigh
        let low = criteria.apply(to: [b, a])
        criteria.sort = .highToLow
        let high = criteria.apply(to: [b, a])
        
        #expect(low.map(\.name) == ["A", "B"])
        #expect(high.map(\.name) == ["A", "B"])
    }
    
    // No sort keeps the API order
    @Test
    func noSortKeepsOriginalOrder() {
        let expensive = makeProduct(id: 1, name: "Expensive", productNumber: "X-1", listPrice: 10.00)
        let cheap = makeProduct(id: 2, name: "Cheap", productNumber: "X-2", listPrice: 2.00)
        let affordable = makeProduct(id: 3, name: "Affordable", productNumber: "X-3", listPrice: 5.00)
        
        var criteria = ProductCriteria()
        criteria.sort = .none
        let result = criteria.apply(to: [expensive, cheap, affordable])
        
        #expect(result.map(\.name) == ["Expensive", "Cheap", "Affordable"])
    }
    
    //test whether the label is seen or not
    @Test
    func sortLabelShownOnlyWhenSorting() {
        var criteria = ProductCriteria()
        
        let before = criteria.activeLabels
        criteria.sort = .lowToHigh
        let after = criteria.activeLabels
        
        #expect(before == [])
        #expect(after == ["Price: Low to High"])
    }
    // when clear is clicked, resets search and sort
    @Test
    func clearResetsSortAndSearch() {
        var criteria = ProductCriteria()
        criteria.searchText = "bk"
        criteria.sort = .highToLow
        criteria.clear()
        
        #expect(criteria == ProductCriteria())
        #expect(criteria.isActive == false)
    }
}
