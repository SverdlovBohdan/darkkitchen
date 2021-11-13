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
    var getCategoriesPublisher: AnyPublisher<ItemCategories, Error>?
    var getProductsPublisher: AnyPublisher<MenuItems, Error>?
    var categories: [Int] = .init()

    func getCategories() -> AnyPublisher<ItemCategories, Error> {
        return getCategoriesPublisher!
    }

    func getProducts(for categoryId: Int) -> AnyPublisher<MenuItems, Error> {
        categories.append(categoryId)
        return getProductsPublisher!
    }
}
