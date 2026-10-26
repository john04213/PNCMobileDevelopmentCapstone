//
//  OrderConverter.swift
//  AdventureWorksMobile
//
//  Created by Miles Eidson on 10/20/26.
//

import SwiftUI

func convertAllOrders(orders: [OrderElement]) -> [Order] {
    var newOrders: [Order] = []
    var previousId: Int = -1
    orders.forEach { order in
        if (previousId == order.orderNumber) {
            if let targetOrder = newOrders.firstIndex(where: { $0.id == previousId }) {
                newOrders[targetOrder].lineItems.append(
                    OrderLineItem(
                        id: order.id,
                        orderNumber: order.orderNumber,
                        productName: order.productName,
                        orderQty: order.orderQty,
                        unitPrice: order.unitPrice,
                        lineTotal: order.lineTotal
                    )
                )
            }
        }
        else {
            previousId = order.orderNumber
            newOrders.append(
                Order(
                    id: order.orderNumber,
                    businessEntityId: order.businessEntityId,
                    customerId: order.customerId,
                    storeName: order.storeName,
                    orderDate: order.orderDate,
                    contactFirstName: order.contactFirstName,
                    contactLastName: order.contactLastName,
                    shipDate: order.shipDate,
                    lineItems: [OrderLineItem(
                        id: order.id,
                        orderNumber: order.orderNumber,
                        productName: order.productName,
                        orderQty: order.orderQty,
                        unitPrice: order.unitPrice,
                        lineTotal: order.lineTotal
                    )]
                )
            )
        }
    }
    return newOrders
}
