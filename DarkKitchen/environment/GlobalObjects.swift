//
//  Interactors.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

public struct GlobalObjectsContainer {
    var menuRepository: ProductsStorageRest!
    var ordersRepository: OrdersStorageRest!

    var menuInteractor: MenuInteractor!
    var ordersInteractor: OrdersInteractor!
}

extension GlobalObjectsContainer {
    static var preview: GlobalObjectsContainer {
        let menuStorage = ProductsStorageRest(endpoint: EndpointConfiguration.test,
                                          networkRequest: URLSession.shared)
        let ordersStorate = OrdersStorageRest(endpoint: EndpointConfiguration.test,
                                              networkRequest: URLSession.shared)

        let menu = MenuInteractor(menuRepository: menuStorage)
        let orders = OrdersInteractor(orderRepository: ordersStorate)

        return .init(menuRepository: menuStorage,
                     ordersRepository: ordersStorate,
                     menuInteractor: menu,
                     ordersInteractor: orders)
    }
}

private struct GlobalObjects: EnvironmentKey {
    static let defaultValue: GlobalObjectsContainer = GlobalObjectsContainer()
}

public extension EnvironmentValues {
    var globalObjects: GlobalObjectsContainer {
        get { self[GlobalObjects.self] }
        set { self[GlobalObjects.self] = newValue }
    }
}
