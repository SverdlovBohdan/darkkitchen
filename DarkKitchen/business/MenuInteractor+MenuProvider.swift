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
    typealias Repository = MenuRepository

    var repository: Repository
    var cancellable: Set<AnyCancellable> = .init()

    init(menuRepository: MenuRepository) {
        self.repository = menuRepository
    }
}

extension MenuProvider where Self: CombineInteractor, Self.Repository == MenuRepository {
    func getFullMenu(menuStateHolder menuState: Binding<MenuState>) {
        menuState.wrappedValue = .loading

        repository.getFullMenu()
            .map { menuItems in
                return MenuState.loaded(menuItems)
            }
            .catch { error in
                Just(MenuState.failed(error))
            }
            .receive(on: RunLoop.main)
            .sink { state in
                menuState.wrappedValue = state
            }
            .store(in: &cancellable)
    }
}
