//
//  Endpoint.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 31.10.2021.
//

import Foundation
import Combine

struct Endpoint {
    var scheme: String
    var host: String
}

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}

struct NetworkRequest<Kind: NetworkRequestKind, Response: Decodable>: CustomStringConvertible {
    private let endpoint: Endpoint
    private let path: String
    private let queryItems: [URLQueryItem]?

    var description: String {
        return "\(endpoint.scheme)\(endpoint.host)/\(path)/\(String(describing: queryItems))"
    }

    init(endpoint: Endpoint, path: String, queryItems: [URLQueryItem]? = nil) {
        self.endpoint = endpoint
        self.path = path
        self.queryItems = queryItems
    }
}

extension NetworkRequest {
    func makeUrlRequest(with data: Kind.RequestData) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = "/\(path)"
        components.queryItems = queryItems

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
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data.body
        }
    }
}

enum NetworkError: Error {
    case invalidEndpoint(endpoint: String)
    case apiError(reason: String)
    case unknown
}

protocol NetworkRequestPublishable {
    func publisher<K, R>(
        for request: NetworkRequest<K, R>,
        using requestData: K.RequestData,
        decoder: JSONDecoder) -> AnyPublisher<R, Error>
}

extension URLSession: NetworkRequestPublishable {
    func publisher<K, R>(
        for request: NetworkRequest<K, R>,
        using requestData: K.RequestData,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, Error> {
        guard let request = request.makeUrlRequest(with: requestData) else {
            return Fail(error: NetworkError.invalidEndpoint(endpoint: request.description))
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }
                if (httpResponse.statusCode == 401) {
                    throw NetworkError.apiError(reason: "Unauthorized");
                }
                if (httpResponse.statusCode == 403) {
                    throw NetworkError.apiError(reason: "Resource forbidden");
                }
                if (httpResponse.statusCode == 404) {
                    throw NetworkError.apiError(reason: "Resource not found");
                }
                if (405..<500 ~= httpResponse.statusCode) {
                    throw NetworkError.apiError(reason: "client error");
                }
                if (500..<600 ~= httpResponse.statusCode) {
                    throw NetworkError.apiError(reason: "server error");
                }

                return data
            })
            .decode(type: NetworkResponse<R>.self, decoder: decoder)
            .map(\.result)
            .eraseToAnyPublisher()
    }
}
