//
//  ProfileRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

protocol ProfileRepository {
    func saveProfile(for user: Client) -> AnyPublisher<Client, Error>
    func loadProfile() -> AnyPublisher<Client, Error>
}
