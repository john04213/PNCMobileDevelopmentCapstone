//
//  DashboardModels.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//


// Mark - Weekly sales 
class DailySales: Identifiable, Hashable, Codable {
    let salesDate: String
    let totalSales: Double
    let totalProfit: Double

    var id: String {
        salesDate
    }

    init(salesDate: String, totalSales: Double, totalProfit: Double) {
        self.salesDate = salesDate
        self.totalSales = totalSales
        self.totalProfit = totalProfit
    }

    static func == (lhs: DailySales, rhs: DailySales) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK - product stock

class ProductStock: Identifiable, Hashable, Codable {
    let productId: Int
    let productName: String
    let stockLevel: Int
    let reorderPoint: Int

    var id: Int {
        productId
    }

    init(productId: Int, productName: String, stockLevel: Int, reorderPoint: Int) {
        self.productId = productId
        self.productName = productName
        self.stockLevel = stockLevel
        self.reorderPoint = reorderPoint
    }

    static func == (lhs: ProductStock, rhs: ProductStock) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK - product sales

class ProductSales: Identifiable, Hashable, Codable {
    let productId: Int
    let productName: String
    let unitsSold: Int
    let unitsInStock: Int

    var id: Int {
        productId
    }

    init(productId: Int, productName: String, unitsSold: Int, unitsInStock: Int) {
        self.productId = productId
        self.productName = productName
        self.unitsSold = unitsSold
        self.unitsInStock = unitsInStock
    }

    static func == (lhs: ProductSales, rhs: ProductSales) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



//Employee shifts

class ShiftEmployee: Identifiable, Hashable, Codable {
    let employeeId: Int
    let firstName: String
    let middleName: String?
    let lastName: String
    let suffix: String?
    let shift: String

    var id: Int {
        employeeId
    }

    var fullName: String {
        var name = firstName
        if let middleName {
            name += " \(middleName)"
        }
        name += " \(lastName)"
        if let suffix {
            name += " \(suffix)"
        }
        return name
    }

    init(employeeId: Int, firstName: String, middleName: String?, lastName: String, suffix: String?, shift: String) {
        self.employeeId = employeeId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.suffix = suffix
        self.shift = shift
    }

    static func == (lhs: ShiftEmployee, rhs: ShiftEmployee) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
