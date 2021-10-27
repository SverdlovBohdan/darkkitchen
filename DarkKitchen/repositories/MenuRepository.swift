//
//  MenuRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import Combine

protocol MenuRepository {
    func getFullMenu() -> AnyPublisher<MenuItems, Error>
}
