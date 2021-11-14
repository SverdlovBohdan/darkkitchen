//
//  ProfileStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

class ProfileStorage: ProfileRepository {
    private static let PROFILE_KEY = "profile"
    private let defaults: UserDefaults = UserDefaults.standard

    func saveProfile(for user: Client) -> AnyPublisher<Client, Error> {
        guard let data: Data = encodeToJson(user) else {
            return Fail(error: RepositoryError.ConvertError)
                .eraseToAnyPublisher()
        }

        defaults.set(data, forKey: ProfileStorage.PROFILE_KEY)
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func loadProfile() -> AnyPublisher<Client, Error> {
        guard let data = defaults.object(forKey: ProfileStorage.PROFILE_KEY) as? Data else {
                  return Fail(error: RepositoryError.ResourceNotFound)
                      .eraseToAnyPublisher()
              }

        guard let user = decodeToJson(data) else {
            return Fail(error: RepositoryError.ConvertError)
                .eraseToAnyPublisher()
        }

        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // MARK: For tests only
    func cleanUp() {
        defaults.removeObject(forKey: ProfileStorage.PROFILE_KEY)
    }

    func encodeToJson(_ user: Client) -> Data? {
        return try? JSONEncoder().encode(user)
    }

    func decodeToJson(_ data: Data) -> Client? {
        return try? JSONDecoder().decode(Client.self, from: data)
    }
}
