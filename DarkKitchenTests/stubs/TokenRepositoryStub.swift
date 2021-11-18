//
//  TokenRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 18.11.2021.
//

import Foundation
import Combine
@testable import DarkKitchen

class TokenRepositoryStub: TokenRepository {
    var getTokenPublisher: AnyPublisher<String, Error> =
        Just("token_stub")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    var setTokenPublisher: AnyPublisher<String, Error> =
        Just("token_stub")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    func getToken() -> AnyPublisher<String, Error> {
        return getTokenPublisher
    }

    func setToken(_ token: String) -> AnyPublisher<String, Error> {
        return setTokenPublisher
    }
}
