//
//  TokenStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

protocol TokenRepository {
    func getToken() -> AnyPublisher<String, Error>
    func setToken(_ token: String) -> AnyPublisher<Void, Error>
}
