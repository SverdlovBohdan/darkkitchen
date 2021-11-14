//
//  AccountRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 14.11.2021.
//

import Foundation
import Combine
@testable import DarkKitchen

class AccountRepositoryStub: AccountRepository {
    var accountInfoPublisher: AnyPublisher<Client, Error>!

    func getAccountInfo() -> AnyPublisher<Client, Error> {
        return accountInfoPublisher
    }
}
