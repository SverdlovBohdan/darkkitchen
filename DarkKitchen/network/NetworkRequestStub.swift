//
//  NetworkRequestStub.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 18.11.2021.
//

import Foundation
import Combine

class NetworkRequestStub: NetworkRequestPublishable {
    var accountPublisher: AnyPublisher<Client, Error>!
    var productsCategoriesPublisher: AnyPublisher<ProductCategories, Error>!
    var productsPublisher: AnyPublisher<Products, Error>!

    func publisher<K, R>(for request: NetworkRequest<K, R>,
                         using requestData: K.RequestData,
                         decoder: JSONDecoder) -> AnyPublisher<R, Error> where K : NetworkRequestKind, R : Decodable, R : Encodable {
        if R.self == Client.self {
            return accountPublisher
                .map { $0 as! R }
            .eraseToAnyPublisher()
        } else if R.self == ProductCategories.self {
            return productsCategoriesPublisher
                .map { $0 as! R }
                .eraseToAnyPublisher()
        } else if R.self == Products.self {
            return productsPublisher
                .map { $0 as! R }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }
    }
}
