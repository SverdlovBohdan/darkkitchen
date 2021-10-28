//
//  MenuRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 22.10.2021.
//

import Foundation
import Combine

@testable import DarkKitchen

class MenuRepositoryStub: MenuRepository {
    enum MenuRepositoryStubBehavior {
        case succeed
        case failedToGetFullMenu
    }

    var items: MenuItems = [Item(), Item()]
    var behavior: MenuRepositoryStubBehavior = .succeed

    func getFullMenu() -> AnyPublisher<MenuItems, Error> {
        switch behavior {
        case .succeed:
            return Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedToGetFullMenu:
            return Fail(error: RepositoryError.RetrieveDataError)
                .eraseToAnyPublisher()
        }
    }
}