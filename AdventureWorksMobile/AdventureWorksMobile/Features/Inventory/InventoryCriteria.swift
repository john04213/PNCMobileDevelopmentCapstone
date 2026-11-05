//
//  InventoryCriteria.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/21/26.
//


import Foundation
struct InventoryCriteria: Equatable {
    var searchText = ""
    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }
    
    var isActive: Bool {
        !trimmedSearch.isEmpty
    }
    
    var activeLabels: [String] {
        var labels: [String] = []
        if !trimmedSearch.isEmpty { labels.append("Search: \"\(trimmedSearch)\"")}
        return labels
    }
    mutating func clear(){
        self =  InventoryCriteria()
    }
    func apply(to items: [InventoryElement]) -> [InventoryElement] {
        var results = items
        if(!trimmedSearch.isEmpty) {
            let search = trimmedSearch.lowercased()
            results = results.filter {item in
                item.productName.lowercased().contains(search) || item.locationName.lowercased().contains(search)
            }
        }
        return results
    }
    
}
