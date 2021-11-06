//
//  OrdersRemoteStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

class OrdersStorageRest: OrdersRepository {
    private let endpoint: EndpointConfiguration
    private let networkRequest: NetworkRequestPublishable

    init(endpoint: EndpointConfiguration, networkRequest: NetworkRequestPublishable) {
        self.endpoint = endpoint
        self.networkRequest = networkRequest
    }

    func pushOrder(order: Order) -> AnyPublisher<PushOrderResult, Error> {
        guard let encodedOrder = try? JSONEncoder().encode(order) else {
            return Fail(error: RepositoryError.PushDataError)
                .eraseToAnyPublisher()
        }

        return networkRequest
            .publisher(for: .pushOrder(endpoint: .init(scheme: endpoint.scheme, host: endpoint.host),
                                       path: RepositoryPaths.pushOrder.rawValue),
                          using: PrivatePushRequestData(token: "1234", body: encodedOrder),
                          decoder: .init())
    }

    func getOrders() -> AnyPublisher<Orders, Error> {
        return networkRequest
            .publisher(for: .getOrders(endpoint: .init(scheme: endpoint.scheme, host: endpoint.host),
                                       path: RepositoryPaths.orders.rawValue),
                          using: "1234", decoder: .init())
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Private, Response == Orders {
    static func getOrders(endpoint: Endpoint, path: String) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path)
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.PrivatePush, Response == PushOrderResult {
    static func pushOrder(endpoint: Endpoint, path: String) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path)
    }
}
