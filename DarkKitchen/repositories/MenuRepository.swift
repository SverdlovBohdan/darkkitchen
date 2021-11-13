//
//  MenuRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine

protocol MenuRepository {
    func getCategories() -> AnyPublisher<ItemCategories, Error>
    func getProducts(for categoryId: Int) -> AnyPublisher<MenuItems, Error>
}
