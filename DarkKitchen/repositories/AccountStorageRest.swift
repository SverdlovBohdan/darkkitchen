//
//  AccountStorage.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import Combine

class AccountStorageRest: AccountRepository {
    private let endpointConfig: EndpointConfiguration
    private let networkRequest: NetworkRequestPublishable
    private var endpoint: Endpoint {
        return Endpoint(scheme: endpointConfig.scheme, host: endpointConfig.host)
    }
    private let tokenProvider: TokenProvidable

    init(endpointConfig: EndpointConfiguration,
         networkRequest: NetworkRequestPublishable,
         tokenProvider: TokenProvidable) {
        self.endpointConfig = endpointConfig
        self.networkRequest = networkRequest
        self.tokenProvider = tokenProvider
    }

    func getAccountInfo() -> AnyPublisher<Client, Error> {
        guard let token = tokenProvider.token else {
            return Fail(error: RepositoryError.ResourceNotFound)
                .eraseToAnyPublisher()
        }

        return networkRequest.publisher(for: .getAccountInfo(endpoint: endpoint,
                                                             path: "me",
                                                             queryItems: [.init(name: "lang", value: "russian")]),
                                           using: token,
                                           decoder: .init())
            .eraseToAnyPublisher()
    }
}

extension NetworkRequest where Kind == NetworkRequestKinds.Private, Response == Client {
    static func getAccountInfo(endpoint: Endpoint, path: String, queryItems: [URLQueryItem]) -> Self {
        return NetworkRequest(endpoint: endpoint, path: path, queryItems: queryItems)
    }
}
