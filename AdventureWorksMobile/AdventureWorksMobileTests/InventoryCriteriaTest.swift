//
//  InventoryCriteria.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/21/26.
//

import Testing
@testable import AdventureWorksMobile

@MainActor
struct InventoryCriteriaTests {
    
    private func makeItem(
        productId: Int,
        name: String,
        location: String,
        safety: Int,
        quantity: Int
    ) ->  InventoryElement {
        InventoryElement(
            productId: productId,
            productName: name,
            productNumber: "Test product",
            safetyStockLevel: safety,
            reorderPoint: 0,
            locationId: 0,
            locationName: location,
            shelf: "Shelf A",
            bin: 0,
            quantity: quantity
        )
    }
    
    // "RACE" finds "Adjustable Race"  -- takes takes 2 rows + acapital-letter search. gives back only the match row
    @Test
    func searchMatchesPartialNameIgnoringCase(){
        let race = makeItem(productId: 1, name: "Adjustable Race", location: "Tool Crib", safety: 1000, quantity: 100)
        let ball = makeItem(productId: 2, name: "Bearing Ball", location: "Tool Crib", safety: 1000, quantity: 100)
        
        var criteria = InventoryCriteria()
        criteria.searchText = "RACE"
        
        let result = criteria.apply(to: [race,ball])
        #expect(result.map(\.productName) == ["Adjustable Race"])
    }
    
    // "paint" finds the row at Paint Shop -- takes 2 rows at different locations, gives back only the Paint Shop row
    @Test
    func searchMatchesLocation(){
        let crib = makeItem(productId: 1, name: "Adjustable Race", location: "Tool Crib", safety: 1000, quantity: 100)
        let paint = makeItem(productId: 2, name: "Bearing Ball", location: "Paint Shop", safety: 1000, quantity: 100)
        
        var criteria = InventoryCriteria()
        criteria.searchText = "paint"
        
        let result = criteria.apply(to: [crib, paint])
        
        #expect(result.map(\.productName) == ["Bearing Ball"])
    }
    
    // " " acts like an empty search -- takes 2 rows + a space-only search, gives back both rows and isActive is false
    @Test
    func spacesOnlySearchIsNotActive() {
        let race = makeItem(productId: 1, name: "Adjustable Race", location: "Tool Crib", safety: 1000, quantity: 100)
        let ball = makeItem(productId: 2, name: "Bearing Ball", location: "Tool Crib", safety: 1000, quantity: 100)
        
        var criteria = InventoryCriteria()
        criteria.searchText = " "
        
        let result = criteria.apply(to: [race, ball])
        
        #expect(criteria.isActive == false)
        #expect(result.count == 2)
    }
    
    // clear() puts every filter back to default -- takes a criteria with a search, leaves it equal to a fresh one
    @Test
    func clearResetsEverything() {
        var criteria = InventoryCriteria()
        criteria.searchText = "race"
        
        criteria.clear()
        
        #expect(criteria == InventoryCriteria())
        #expect(criteria.isActive == false)
    }
    // the chips list each actove filter -- takes a criteria before and after a search, gives back [] then one trimmed label
    @Test
    func activeLabelsListEachCriterion() {
       var criteria = InventoryCriteria()
        
        #expect(criteria.activeLabels == [])
        
        criteria.searchText = " race "
        
        #expect(criteria.activeLabels == ["Search: \"race\""])
        
    }
    
    
    
    
//    @Test
//    func lowStockAddsAllLocation(){
//        // arrange
//        let race1 = makeItem(productId: 1, name: "Adjustable Race", location: "Tool Crib", safety: 1000, quantity: 300)
//        let race2 = makeItem(productId: 2, name: "Adjustable Race", location: "Paint Shop", safety: 1000, quantity: 800)
//        let ball = makeItem(productId: 2, name: "Bearing Ball", location: "Tool Crib", safety: 500, quantity: 100)
//        
//        var criteria = InventoryCriteria()
//        criteria.lowStockOnly = true
//        
//        // act
//        let result = criteria.apply(to: [race1, race2, ball])
//        
//        // assert
//        #expect(result.map(\.productName) == ["Bearing Ball"])
//        
//    }
}
