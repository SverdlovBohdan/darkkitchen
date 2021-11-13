//
//  MenuRemoteRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

class ProductsStorageRest: ProductsRepository {
    private let endpointConfig: EndpointConfiguration
    private let networkRequest: NetworkRequestPublishable
    private var endpoint: Endpoint {
        return Endpoint(scheme: endpointConfig.scheme, host: endpointConfig.host)
    }

    init(endpoint: EndpointConfiguration, networkRequest: NetworkRequestPublishable) {
        self.endpointConfig = endpoint
        self.networkRequest = networkRequest
    }

    func getCategories() -> AnyPublisher<ProductCategories, Error> {
        return networkRequest.publisher(
            for: .getCategories(endpoint: endpoint,
                                path: RepositoryPaths.categories.rawValue,
                                queryItems: [.init(name: "lang", value: "russian")]),
               using: Void(), decoder: .init())
    }

    func getProducts(for categoryId: Int) -> AnyPublisher<Products, Error> {
        return networkRequest.publisher(
            for: .getProducts(endpoint: endpoint,
                              path: RepositoryPaths.products.rawValue,
                              queryItems: [.init(name: "lang", value: "russian"),
                                           .init(name: "category", value: "\(categoryId)"),
                                           .init(name: "withChildren", value: "true"),
                                           .init(name: "type", value: "1")]),
               using: Void(), decoder: .init())
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Public, Response == ProductCategories {
    static func getCategories(endpoint: Endpoint, path: String, queryItems: [URLQueryItem]) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path, queryItems: queryItems)
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Public, Response == Products {
    static func getProducts(endpoint: Endpoint, path: String, queryItems: [URLQueryItem]) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path, queryItems: queryItems)
    }
}
