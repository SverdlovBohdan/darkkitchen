//
//  MenuRemoteRepository.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import Foundation
import Combine

class MenuStorageRest: MenuRepository {
    private let endpoint: EndpointConfiguration
    private let networkRequest: NetworkRequestPublishable

    init(endpoint: EndpointConfiguration, networkRequest: NetworkRequestPublishable) {
        self.endpoint = endpoint
        self.networkRequest = networkRequest
    }

    func getFullMenu() -> AnyPublisher<MenuItems, Error> {
        return networkRequest
            .publisher(for: .getFullMenu(endpoint: .init(scheme: endpoint.scheme, host: endpoint.host),
                                         path: RepositoryPaths.fullMenu.rawValue),
                          using: Void(), decoder: .init())
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Public, Response == MenuItems {
    static func getFullMenu(endpoint: Endpoint, path: String) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path)
    }
}
