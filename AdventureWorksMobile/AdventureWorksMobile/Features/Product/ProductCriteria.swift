//
//  ProductCriteria.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/26/26.
//


import Foundation
enum PriceSort: String, CaseIterable {
    case none = "Default"
    case lowToHigh = "Price: Low to High"
    case highToLow = "Price: High to Low"
}

struct ProductCriteria: Equatable {
    var searchText = ""
    var sort = PriceSort.none
    
    private var trimmedSearch: String { searchText.trimmingCharacters(in: .whitespaces)
    }
    
    var isActive: Bool {
        !trimmedSearch.isEmpty || sort != .none
    }
    
    var activeLabels: [String] {
        var labels: [String] = []
        if !trimmedSearch.isEmpty{ labels.append("Search: \"\(trimmedSearch)\"")}
        if( sort != .none) { labels.append(sort.rawValue)}
        return labels
    }
    mutating func clear() {
        self = ProductCriteria()
    }
    func apply(to items: [ProductElement]) -> [ProductElement] {
        var results = items
        if !trimmedSearch.isEmpty {
            let search = trimmedSearch.lowercased()
            results = results.filter {item in
                item.name.lowercased().contains(search) || item.productNumber.lowercased().contains(search)
            }
        }
        switch sort {
        case .none: break
        case .lowToHigh:
            results.sort {a, b  in
                if a.listPrice != b.listPrice {return a.listPrice < b.listPrice}
                return a.name < b.name
            }
        case .highToLow:
            results.sort {a, b  in
                if a.listPrice != b.listPrice {
                    return a.listPrice > b.listPrice
                }
                return a.name < b.name
            }
        }
        return results
    }
}
