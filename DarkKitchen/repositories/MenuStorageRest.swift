//
//  MenuRemoteRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

class MenuStorageRest: MenuRepository {
    private let host: String

    init(host: String) {
        self.host = host
    }

    func getFullMenu() -> AnyPublisher<MenuItems, Error> {
        return URLSession.shared
            .publisher(for: .getFullMenu(host: host, path: "/full-menu"),
                       using: Void())
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Public, Response == MenuItems {
    static func getFullMenu(host: String, path: String) -> Self {
        return NetworkRequest(host: host, path: path)
    }
}
