//
//  OrderInteractorTests.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//
import XCTest

import SwiftUI

@testable import DarkKitchen

class OrderInteractorTest: XCTestCase {
    var repository: OrdersRepositoryStub!
    var interactor: OrdersInteractor!

    var ordersState: OrdersState!
    var expectation: XCTestExpectation!
    var expectedOrdersStates: [OrdersState]!
    var incomingOrdersStates: [OrdersState]!

    var pushOrderState: PushOrderState!
    var expectedPushOrderState: [PushOrderState]!
    var incomingPushOrderState: [PushOrderState]!

    override func setUpWithError() throws {
        ordersState = .idle
        expectation = .init()
        expectedOrdersStates = .init()
        incomingOrdersStates = .init()
        pushOrderState = .idle
        expectedPushOrderState = .init()
        incomingPushOrderState = .init()
    }

    override func tearDownWithError() throws {
    }

    func testCanRetrieveOrders() throws {
        repository = OrdersRepositoryStub()
        interactor = OrdersInteractor(orderRepository: repository)

        interactor.getOrders(ordersStateHolder: .init(get: {
            self.ordersState
        }, set: { newState in
            switch newState {
            case .loaded(_):
                print("\(newState)")
                self.incomingOrdersStates.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingOrdersStates.append(newState)
            }
            self.ordersState = newState
        }))


        wait(for: [expectation], timeout: 10.0)

        expectedOrdersStates = [.loading, .loaded([Order(), Order()])]
        XCTAssertEqual(expectedOrdersStates, incomingOrdersStates)
    }

    func testSetsFailedOrdersStateIfUnableToGetOrders() {
        repository = OrdersRepositoryStub()
        repository.behavior = .failedToGetOrders
        interactor = OrdersInteractor(orderRepository: repository)

        interactor.getOrders(ordersStateHolder: .init(get: {
            self.ordersState
        }, set: { newState in
            switch newState {
            case .failed(_):
                print("\(newState)")
                self.incomingOrdersStates.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingOrdersStates.append(newState)
            }
            self.ordersState = newState
        }))


        wait(for: [expectation], timeout: 10.0)

        expectedOrdersStates = [.loading, .failed(RepositoryError.RetrieveDataError)]
        XCTAssertEqual(expectedOrdersStates, incomingOrdersStates)
    }

    func testCanSendOrder() {
        repository = OrdersRepositoryStub()
        interactor = OrdersInteractor(orderRepository: repository)

        interactor.sendOrder(pushOrderStateHolder: .init(get: {
            self.pushOrderState
        }, set: { newState in
            switch newState {
            case .pushed:
                print("\(newState)")
                self.incomingPushOrderState.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingPushOrderState.append(newState)
            }
        }), order: Order())

        wait(for: [expectation], timeout: 10.0)

        expectedPushOrderState = [.pushing(Order()), .pushed]
        XCTAssertEqual(expectedPushOrderState, incomingPushOrderState)
    }

    func testSetsFailedPushOrderStateIfUnableToSendOrder() {
        repository = OrdersRepositoryStub()
        repository.behavior = .failedToPushOrder
        interactor = OrdersInteractor(orderRepository: repository)

        interactor.sendOrder(pushOrderStateHolder: .init(get: {
            self.pushOrderState
        }, set: { newState in
            switch newState {
            case .failed(_, _):
                print("\(newState)")
                self.incomingPushOrderState.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingPushOrderState.append(newState)
            }
        }), order: Order())

        wait(for: [expectation], timeout: 10.0)

        expectedPushOrderState = [.pushing(Order()), .failed(RepositoryError.PushDataError, Order())]
        XCTAssertEqual(expectedPushOrderState, incomingPushOrderState)
    }
}
