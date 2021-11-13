//
//  OrderRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

@testable import DarkKitchen

class OrdersRepositoryStub: OrdersRepository {
    enum RepositoryBehavior {
        case succeed
        case failedToGetOrders
        case failedToPushOrder
    }

    var items: Products = [Product(name: "", price: 0, description: "",
                                 category: .init(id: 0, name: ""), main_image: .init(url: "")),
                            Product(name: "", price: 0, description: "",
                                 category: .init(id: 0, name: ""), main_image: .init(url: ""))]
    var behavior: RepositoryBehavior = .succeed

    func getOrders() -> AnyPublisher<Orders, Error> {
        switch behavior {
        case .succeed:
            return Just([Order(), Order()])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        default:
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }
    }

    func pushOrder(order: Order) -> AnyPublisher<PushOrderResult, Error> {
        switch behavior {
        case .succeed:
            return Just(PushOrderResult())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        default:
            return Fail(error: RepositoryError.PushDataError)
                .eraseToAnyPublisher()
        }
    }
}

