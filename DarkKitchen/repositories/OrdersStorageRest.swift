//
//  OrdersRemoteStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

class OrdersStorageRest: OrdersRepository {
    private let host: String

    init(host: String) {
        self.host = host
    }

    func pushOrder(order: Order) -> AnyPublisher<PushOrderResult, Error> {
        guard let encodedOrder = try? JSONEncoder().encode(order) else {
            return Fail(error: RepositoryError.PushDataError)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .publisher(for: .pushOrder(host: host, path: "push-order"),
                       using: PrivatePushRequestData(token: "1234", body: encodedOrder))
    }

    func getOrders() -> AnyPublisher<Orders, Error> {
        return URLSession.shared
            .publisher(for: .getOrders(host: host, path: "my-orders"), using: "1234")
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Private, Response == Orders {
    static func getOrders(host: String, path: String) -> Self {
        return NetworkRequest(host: host, path: path)
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.PrivatePush, Response == PushOrderResult {
    static func pushOrder(host: String, path: String) -> Self {
        return NetworkRequest(host: host, path: path)
    }
}
