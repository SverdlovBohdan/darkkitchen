//
//  TokenStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

class TokenStorage: TokenRepository {
    private static let TOKEN_KEY: String = "token"
    private let defaults: UserDefaults = UserDefaults.standard

    func getToken() -> AnyPublisher<String, Error> {
        guard let token = defaults.object(forKey: TokenStorage.TOKEN_KEY) as? String else {
            return Fail(error: RepositoryError.ResourceNotFound)
                .eraseToAnyPublisher()
        }

        return Just(token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func setToken(_ token: String) -> AnyPublisher<String, Error> {
        defaults.set(token, forKey: TokenStorage.TOKEN_KEY)
        return Just(token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    /// For tests only
    func cleanUp() {
        defaults.removeObject(forKey: TokenStorage.TOKEN_KEY)
    }
}
