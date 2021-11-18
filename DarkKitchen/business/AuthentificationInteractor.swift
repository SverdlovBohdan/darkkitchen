//
//  AuthentificationInteractor.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import SwiftUI
import Combine

class AuthentificationInteractor: TokenReader, Authentication {
    private let tokenRepository: TokenRepository
    var cancellable: Set<AnyCancellable> = .init()

    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    func readToken(to state: Binding<TokenState>) {
        tokenRepository.getToken()
            .map { token in
                return TokenState.exist(token: token)
            }
            .replaceError(with: TokenState.absent)
            .receive(on: RunLoop.main)
            .sink { tokenState in
                state.wrappedValue = tokenState
            }
            .store(in: &cancellable)
    }

    func logIn(name: String, password: String) {
        /// TODO
    }

    func logOut() {
        /// TODO
    }
}
