//
//  OrderRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

@testable import DarkKitchen

class OrderRepositoryStub: OrderRepository {
    enum RepositoryBehavior {
        case succeed
        case failedToGetOrders
        case failedToPushOrder
    }

    var items: MenuItems = [Item(), Item()]
    var behavior: RepositoryBehavior = .succeed

    func getOrders() -> AnyPublisher<Orders, Error> {
        switch behavior {
        case .succeed:
            return Just([Order(), Order()])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        default:
            return Fail(error: RepositoryError.RetrieveDataError)
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
