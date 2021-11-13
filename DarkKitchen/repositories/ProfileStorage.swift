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
        guard let data: Data = try? JSONEncoder().encode(user) else {
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

        guard let user = try? JSONDecoder().decode(Client.self, from: data) else {
            return Fail(error: RepositoryError.ConvertError)
                .eraseToAnyPublisher()
        }

        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    /// For tests only
    func cleanUp() {
        defaults.removeObject(forKey: ProfileStorage.PROFILE_KEY)
    }

    /// For tests only
    func saveCustomString(_ text: String) {
        defaults.set(text, forKey: ProfileStorage.PROFILE_KEY)
    }
}
