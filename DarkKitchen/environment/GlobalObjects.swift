//
//  Interactors.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine
import SwiftUI

public struct GlobalObjectsContainer {
    var appState: AppState!

    var menuRepository: ProductsStorageRest!
    var ordersRepository: OrdersStorageRest!
    var accountRepository: AccountRepository!
    var profileRepository: ProfileRepository!
    var tokenRepository: TokenRepository!

    var menuInteractor: MenuInteractor!
    var ordersInteractor: OrdersInteractor!
    var authInteractor: AuthentificationInteractor!
    var profileInteractor: ProfileInteractor!
}

extension GlobalObjectsContainer {
    static var development: GlobalObjectsContainer {
        /// Stubs
        let network = NetworkRequestStub()
        network.accountPublisher = Just(Client(name: "testClient", phone: "+000 000 00000",
                                               email: "test@email.com", mainAddress: "street"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let productCategories = [ProductCategory(id: 1, name: "category1"),
                                 ProductCategory(id: 2, name: "category2"),
                                 ProductCategory(id: 3, name: "category3")]
        network.productsCategoriesPublisher = Just(productCategories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let products = [Product(name: "test1", price: 13, description: "des", category: productCategories[0], main_image: .init(url: "http://")),
                        Product(name: "test2", price: 14, description: "des", category: productCategories[1], main_image: .init(url: "http://")),
                        Product(name: "test3", price: 13, description: "des", category: productCategories[2], main_image: .init(url: "http://"))]
        network.productsPublisher = Just(products)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        ///  Application globals.
        let appState: AppState = AppState()

        let menuStorage = ProductsStorageRest(endpoint: EndpointConfiguration.test,
                                              networkRequest: network)
        let ordersStorage = OrdersStorageRest(endpoint: EndpointConfiguration.test,
                                              networkRequest: URLSession.shared)
        let accountStorage = AccountStorageRest(endpointConfig: EndpointConfiguration.test,
                                                networkRequest: network,
                                                tokenProvider: appState)
        let profileStorage = ProfileStorage()
        profileStorage.cleanUp()
        let tokenStorage = TokenStorage()
        tokenStorage.cleanUp()

        let menu = MenuInteractor(menuRepository: menuStorage)
        let orders = OrdersInteractor(orderRepository: ordersStorage)
        let auth = AuthentificationInteractor(tokenRepository: tokenStorage)
        let profile = ProfileInteractor(profileRepository: profileStorage,
                                        accountRepository: accountStorage)

        return .init(appState: appState,
                     menuRepository: menuStorage,
                     ordersRepository: ordersStorage,
                     accountRepository: accountStorage,
                     profileRepository: profileStorage,
                     tokenRepository: tokenStorage,
                     menuInteractor: menu,
                     ordersInteractor: orders,
                     authInteractor: auth,
                     profileInteractor: profile)
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
