//
//  MenuRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine

protocol ProductsRepository {
    func getCategories() -> AnyPublisher<ProductCategories, Error>
    func getProducts(for categoryId: Int) -> AnyPublisher<Products, Error>
}
