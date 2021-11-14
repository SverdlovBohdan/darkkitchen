//
//  ProfileRepositoryStub.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 14.11.2021.
//

import Foundation
import Combine
@testable import DarkKitchen

class ProfileRepositoryStub: ProfileRepository {
    var savePublisher: AnyPublisher<Client, Error>!
    var loadPublisher: AnyPublisher<Client, Error>!

    func saveProfile(for user: Client) -> AnyPublisher<Client, Error> {
        return savePublisher
    }

    func loadProfile() -> AnyPublisher<Client, Error> {
        return loadPublisher
    }
}
