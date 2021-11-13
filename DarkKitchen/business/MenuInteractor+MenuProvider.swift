//
//  Menu.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine
import SwiftUI

class MenuInteractor: CombineInteractor, MenuProvider {
    typealias Repository = ProductsRepository

    var repository: Repository
    var cancellable: Set<AnyCancellable> = .init()

    init(menuRepository: ProductsRepository) {
        self.repository = menuRepository
    }
}

extension MenuProvider where Self: CombineInteractor, Self.Repository == ProductsRepository {
    func getFullMenu(appStateHolder appState: Binding<AppState>) {
        appState.userData.fullMenuState.wrappedValue = .loading
        appState.userData.categoriesState.wrappedValue = .loading

        repository.getCategories()
            .flatMap { categories -> AnyPublisher<[Products], Error> in
                appState.userData.categoriesState.wrappedValue = CategoriesState.loaded(categories)

                return Publishers.MergeMany<AnyPublisher<Products, Error>>(categories.compactMap{ category -> AnyPublisher<Products, Error> in
                    return self.repository.getProducts(for: category.id)
                })
                    .collect()
                    .eraseToAnyPublisher()
            }
            .map { products in
                return MenuState.loaded(Array(products.joined()))
            }
            .catch { error in
                Just(MenuState.failed(error))
            }
            .receive(on: RunLoop.main)
            .sink { state in
                if case MenuState.failed(let error) = state {
                    appState.userData.categoriesState.wrappedValue = CategoriesState.failed(error)
                }
                appState.userData.fullMenuState.wrappedValue = state
            }
            .store(in: &cancellable)
    }
}
