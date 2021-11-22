//
//  Interactors.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine
import SwiftUI

public protocol InjectionKey {
    associatedtype Value

    static var currentValue: Self.Value { get set }
}

struct InjectedValues {
    private static var current = InjectedValues()

    static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }

    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

// 1. Add interface default implementation
// private struct ProductsRepositoryKey: InjectionKey {
//    static var currentValue: ProductsRepository = ProductsStorageRest(endpoint: EndpointConfiguration.test,
//                                                                      networkRequest: URLSession.shared)
// }
//
// 2. Add new binding. Extend `InjectedValues` by interface
// var productsRepository: ProductsRepository {
//     get { Self[ProductsRepositoryKey.self] }
//     set { Self[ProductsRepositoryKey.self] = newValue }
//
// 3. Use:
// InjectedValues[\.productsRepository] = productsStorage
// @Injected(\.tokenReader) var tokenReader: TokenReader
// }

/// TODO: Change to empty stubs
private struct ProductsRepositoryKey: InjectionKey {
    static var currentValue: ProductsRepository = ProductsStorageRest(endpoint: EndpointConfiguration.test,
                                                                      networkRequest: URLSession.shared)
}

private struct OrdersRepositoryKey: InjectionKey {
    static var currentValue: OrdersRepository = OrdersStorageRest(endpoint: EndpointConfiguration.test,
                                                                  networkRequest: URLSession.shared)
}

private struct AccountRepositoryKey: InjectionKey {
    static var currentValue: AccountRepository = AccountStorageRest(endpointConfig: EndpointConfiguration.test,
                                                                    networkRequest: URLSession.shared,
                                                                    tokenProvider: AppState())
}

private struct ProfileRepositoryKey: InjectionKey {
    static var currentValue: ProfileRepository = ProfileStorage()
}

private struct TokenRepositoryKey: InjectionKey {
    static var currentValue: TokenRepository = TokenStorage()
}

private struct ProductsProviderKey: InjectionKey {
    static var currentValue: MenuProvider = MenuInteractor(
        menuRepository: ProductsStorageRest(endpoint: EndpointConfiguration.test,
                                            networkRequest: URLSession.shared))
}

private struct OrdersProviderKey: InjectionKey {
    static var currentValue: OrdersProvider = OrdersInteractor(
        orderRepository: OrdersStorageRest(endpoint: EndpointConfiguration.test,
                                           networkRequest: URLSession.shared))
}

private struct OrderSenderKey: InjectionKey {
    static var currentValue: OrderSender = OrdersInteractor(
        orderRepository: OrdersStorageRest(endpoint: EndpointConfiguration.test,
                                           networkRequest: URLSession.shared))
}

private struct TokenReaderKey: InjectionKey {
    static var currentValue: TokenReader = AuthentificationInteractor(tokenRepository: TokenStorage())
}

private struct AuthenticationKey: InjectionKey {
    static var currentValue: Authentication = AuthentificationInteractor(tokenRepository: TokenStorage())
}

private struct ProfileProviderKey: InjectionKey {
    static var currentValue: ProfileProvider = ProfileInteractor(
        profileRepository: ProfileStorage(),
        accountRepository: AccountStorageRest(endpointConfig: EndpointConfiguration.test,
                                              networkRequest: URLSession.shared,
                                              tokenProvider: AppState()))
}

extension InjectedValues {
    var productsRepository: ProductsRepository {
        get { Self[ProductsRepositoryKey.self] }
        set { Self[ProductsRepositoryKey.self] = newValue }
    }

    var ordersRepository: OrdersRepository {
        get { Self[OrdersRepositoryKey.self] }
        set { Self[OrdersRepositoryKey.self] = newValue }
    }

    var accountRepository: AccountRepository {
        get { Self[AccountRepositoryKey.self] }
        set { Self[AccountRepositoryKey.self] = newValue }
    }

    var profileRepository: ProfileRepository {
        get { Self[ProfileRepositoryKey.self] }
        set { Self[ProfileRepositoryKey.self] = newValue }
    }

    var tokenRepository: TokenRepository {
        get { Self[TokenRepositoryKey.self] }
        set { Self[TokenRepositoryKey.self] = newValue }
    }

    var productsProvider: MenuProvider {
        get { Self[ProductsProviderKey.self] }
        set { Self[ProductsProviderKey.self] = newValue }
    }

    var orderSender: OrderSender {
        get { Self[OrderSenderKey.self] }
        set { Self[OrderSenderKey.self] = newValue }
    }

    var ordersProvider: OrdersProvider {
        get { Self[OrdersProviderKey.self] }
        set { Self[OrdersProviderKey.self] = newValue }
    }

    var tokenReader: TokenReader {
        get { Self[TokenReaderKey.self] }
        set { Self[TokenReaderKey.self] = newValue }
    }

    var authentification: Authentication {
        get { Self[AuthenticationKey.self] }
        set { Self[AuthenticationKey.self] = newValue }
    }

    var profileProvider: ProfileProvider {
        get { Self[ProfileProviderKey.self] }
        set { Self[ProfileProviderKey.self] = newValue }
    }
}

enum GlobalObjectsContainer {
    static func injectDevelopmentEnvironment(appState: AppState) {
        print("Inject Development environment")

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
        let productsStorage = ProductsStorageRest(endpoint: EndpointConfiguration.test,
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

        let menu = MenuInteractor(menuRepository: productsStorage)
        let orders = OrdersInteractor(orderRepository: ordersStorage)
        let auth = AuthentificationInteractor(tokenRepository: tokenStorage)
        let profile = ProfileInteractor(profileRepository: profileStorage,
                                        accountRepository: accountStorage)

        InjectedValues[\.productsRepository] = productsStorage
        InjectedValues[\.ordersRepository] = ordersStorage
        InjectedValues[\.accountRepository] = accountStorage
        InjectedValues[\.profileRepository] = profileStorage
        InjectedValues[\.tokenRepository] = tokenStorage
        InjectedValues[\.productsProvider] = menu
        InjectedValues[\.orderSender] = orders
        InjectedValues[\.ordersProvider] = orders
        InjectedValues[\.tokenReader] = auth
        InjectedValues[\.authentification] = auth
        InjectedValues[\.profileProvider] = profile
    }
}
