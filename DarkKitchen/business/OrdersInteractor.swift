//
//  OrderInteractor.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI
import Combine

class OrdersInteractor: CombineInteractor, OrdersProvider, OrderSender {
    typealias Repository = OrdersRepository

    var repository: Repository
    var cancellable: Set<AnyCancellable> = .init()

    init(orderRepository: Repository) {
        self.repository = orderRepository
    }
}

extension OrdersProvider where Self: CombineInteractor, Self.Repository == OrdersRepository {
    func getOrders(ordersStateHolder ordersState: Binding<OrdersState>) {
        ordersState.wrappedValue = .loading

        repository.getOrders()
            .map { orders in
                return OrdersState.loaded(orders)
            }
            .catch { error in
                Just(OrdersState.failed(error))
            }
            .receive(on: RunLoop.main)
            .sink { state in
                ordersState.wrappedValue = state
            }
            .store(in: &cancellable)
    }
}

extension OrderSender where Self: CombineInteractor, Self.Repository == OrdersRepository {
    func sendOrder(pushOrderStateHolder pushOrderState: Binding<PushOrderState>, order: Order) {
        pushOrderState.wrappedValue = .pushing(order)

        repository.pushOrder(order: order)
            .map { result in
                return PushOrderState.pushed
            }
            .catch { error in
                Just(PushOrderState.failed(error, order))
            }
            .receive(on: RunLoop.main)
            .sink { state in
                pushOrderState.wrappedValue = state
            }
            .store(in: &cancellable)
    }
}
