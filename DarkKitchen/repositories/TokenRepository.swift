//
//  TokenStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

protocol TokenRepository {
    @discardableResult
    func getToken() -> AnyPublisher<String, Error>

    @discardableResult
    func setToken(_ token: String) -> AnyPublisher<String, Error>
}
