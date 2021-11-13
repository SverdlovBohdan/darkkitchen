//
//  AccountRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

protocol AccountRepository {
    func getAccountInfo() -> AnyPublisher<Client, Error>
}
