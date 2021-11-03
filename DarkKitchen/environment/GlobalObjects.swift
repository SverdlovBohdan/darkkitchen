//
//  Interactors.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

public struct GlobalObjectsContainer {
    var configuration: Configuration!

    var menuRepository: MenuStorageRest!
    var ordersRepository: OrdersStorageRest!

    var menuInteractor: MenuInteractor!
    var ordersInteractor: OrdersInteractor!
}

extension GlobalObjectsContainer {
    static var preview: GlobalObjectsContainer {
        let developmentConfiguration = Configuration(kind: .development)

        let menuStorage = MenuStorageRest(host: developmentConfiguration.host)
        let ordersStorate = OrdersStorageRest(host: developmentConfiguration.host)

        let menu = MenuInteractor(menuRepository: menuStorage)
        let orders = OrdersInteractor(orderRepository: ordersStorate)

        return .init(configuration: developmentConfiguration,
                     menuRepository: menuStorage,
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
