//
//  ProductElement.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//

import Foundation

struct ProductElement: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let productNumber: String
    let summary: String?
    let thumbnailPhoto: String
    let thumbnailPhotoFileName: String
    let warranty: String?
    let color: String?
    let listPrice: Double

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name = "name"
        case productNumber = "productNumber"
        case summary = "summary"
        case thumbnailPhoto = "thumbnailPhoto"
        case thumbnailPhotoFileName = "thumbnailPhotoFileName"
        case warranty = "warranty"
        case color = "color"
        case listPrice = "listPrice"
    }
    
    init(id: Int, name: String, productNumber: String, summary: String?, thumbnailPhoto: String, thumbnailPhotoFileName: String, warranty: String?, color: String?, listPrice: Double) {
        self.id = id
        self.name = name
        self.productNumber = productNumber
        self.summary = summary
        self.thumbnailPhoto = thumbnailPhoto
        self.thumbnailPhotoFileName = thumbnailPhotoFileName
        self.warranty = warranty
        self.color = color
        self.listPrice = listPrice
    }
    
    static func == (lhs: ProductElement, rhs: ProductElement) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
