//
//  MenuRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 22.10.2021.
//

import Foundation
import Combine

@testable import DarkKitchen

class ProductsRepositoryStub: ProductsRepository {
    var getCategoriesPublisher: AnyPublisher<ProductCategories, Error>?
    var getProductsPublisher: AnyPublisher<Products, Error>?
    var categories: [Int] = .init()

    func getCategories() -> AnyPublisher<ProductCategories, Error> {
        return getCategoriesPublisher!
    }

    func getProducts(for categoryId: Int) -> AnyPublisher<Products, Error> {
        categories.append(categoryId)
        return getProductsPublisher!
    }
}
