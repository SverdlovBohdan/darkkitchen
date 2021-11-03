//
//  OrderRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine
import RepositoryRequestPerformer

protocol OrdersRepository {
    func pushOrder(order: Order) -> AnyPublisher<PushOrderResult, Error>
    func getOrders() -> AnyPublisher<Orders, Error>
}
