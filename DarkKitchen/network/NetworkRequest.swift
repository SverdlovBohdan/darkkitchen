//
//  Endpoint.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 31.10.2021.
//

import Foundation
import Combine

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}

struct NetworkRequest<Kind: NetworkRequestKind, Response: Decodable> {
    private let host: String
    private let path: String
    private let queryItems: [String:String]?

    init(host: String, path: String, queryItems: [String:String]? = nil) {
        self.host = host
        self.path = path
        self.queryItems = nil
    }
}

extension NetworkRequest {
    func makeUrlRequest(with data: Kind.RequestData) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = "/\(path)"

        if let queryItems = queryItems {
            components.queryItems = queryItems.compactMap { name, value in
                return URLQueryItem(name: name, value: value)
            }
        }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)

        Kind.prepare(&request, with: data)
        return request
    }
}

struct PrivatePushRequestData {
    let token: String
    let body: Data

    // todo: extra headers
}

protocol NetworkRequestKind {
    associatedtype RequestData

    static func prepare(_ request: inout URLRequest, with data: RequestData)
}

enum NetworkRequestKinds {
    enum Public: NetworkRequestKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
    }

    enum Private: NetworkRequestKind {
        static func prepare(_ request: inout URLRequest, with token: String) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    enum PrivatePush: NetworkRequestKind {
        static func prepare(_ request: inout URLRequest, with data: PrivatePushRequestData) {
            request.httpMethod = "POST"
            request.addValue("Bearer \(data.token)", forHTTPHeaderField: "Authorization")
            request.httpBody = data.body
        }
    }
}

enum NetworkingError<K: NetworkRequestKind, R: Decodable>: Error {
    case InvalidEndpoint(enpoint: NetworkRequest<K, R>)
}

extension URLSession {
    func publisher<K, R>(
        for request: NetworkRequest<K, R>,
        using requestData: K.RequestData,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, Error> {
        guard let request = request.makeUrlRequest(with: requestData) else {
            return Fail(error: NetworkingError.InvalidEndpoint(enpoint: request))
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<R>.self, decoder: decoder)
            .map(\.result)
            .eraseToAnyPublisher()
    }
}
