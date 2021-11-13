//
//  NetworkRequestTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 04.11.2021.
//

import XCTest
import Combine
@testable import DarkKitchen

struct ResponseStub: Codable {
    var id: Int = 1
}

extension XCTestCase {
    func awaitCompletion<T: Publisher>(
        of publisher: T,
        timeout: TimeInterval = 10.0) throws -> [T.Output] {
            let expectation = self.expectation(description: "Awaiting publisher completion")

            var completion: Subscribers.Completion<T.Failure>?
            var output = [T.Output]()

            let cancellable = publisher.sink {
                completion = $0
                expectation.fulfill()
            } receiveValue: {
                output.append($0)
            }

            waitForExpectations(timeout: timeout)

            switch completion {
            case .failure(let error):
                throw error
            case .finished:
                return output
            case nil:
                cancellable.cancel()
                return []
            }
        }
}

class NetworkRequestTest: XCTestCase {

    func expectedUrl(withPath path: String) throws -> URL {
        let url = URL(string: "\(EndpointConfiguration.test.fullEndpoint)/\(path)")
        return try XCTUnwrap(url)
    }

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testCanMakeUrlPublicRequest() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Public, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let urlRequest = try XCTUnwrap(request.makeUrlRequest(with: ()))
        try XCTAssertEqual(urlRequest.url, expectedUrl(withPath: "endpoint"))
    }

    func testCanMakeUrlPublicRequestWithQueryItems() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Public, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint",
            queryItems: [URLQueryItem(name: "a", value: "1"), URLQueryItem(name: "b", value: "2")])
        let urlRequest = try XCTUnwrap(request.makeUrlRequest(with: ()))
        try XCTAssertEqual(urlRequest.url, expectedUrl(withPath: "endpoint?a=1&b=2")) // fix dict order
    }

    func testCanMakeUrlPrivateRequest() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Private, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let urlRequest = try XCTUnwrap(request.makeUrlRequest(with: "1234"))
        let _ = try XCTUnwrap(urlRequest.allHTTPHeaderFields?.contains(where: { (key: String, value: String) in
            return key == "Authorization" && value.hasSuffix("1234")
        }))
        try XCTAssertEqual(urlRequest.url, expectedUrl(withPath: "endpoint"))
    }

    func testCanMakeUrlPrivateRequestWithQueryItems() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Private, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint",
            queryItems: [URLQueryItem(name: "a", value: "1"), URLQueryItem(name: "b", value: "2")])
        let urlRequest = try XCTUnwrap(request.makeUrlRequest(with: "1234"))
        let _ = try XCTUnwrap(urlRequest.allHTTPHeaderFields?.contains(where: { (key: String, value: String) in
            return key == "Authorization" && value.hasSuffix("1234")
        }))
        try XCTAssertEqual(urlRequest.url, expectedUrl(withPath: "endpoint?a=1&b=2"))
    }

    func testCanMakeUrlPrivatePushRequest() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.PrivatePush, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let urlRequest = try XCTUnwrap(request.makeUrlRequest(with: .init(token: "1234", body: .init())))
        let _ = try XCTUnwrap(urlRequest.allHTTPHeaderFields?.contains(where: { (key: String, value: String) in
            return key == "Authorization" && value.hasSuffix("1234")
        }))
        try XCTAssertEqual(urlRequest.url, expectedUrl(withPath: "endpoint"))
        var _ = try XCTUnwrap(urlRequest.httpBody)
        if let httpMethod = urlRequest.httpMethod {
            XCTAssertEqual(httpMethod, "POST")
        }
        else {
            XCTFail("Expected POST HTTP method type")
        }
    }

    func testCanDecodeResponse() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Public, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let responder: UrlProtocolMock = .init()
        UrlProtocolMock.statusCode = 200
        UrlProtocolMock.data = try JSONEncoder().encode(ResponseStub())
        let urlSession: URLSession = URLSession(mockResponder: responder)
        let result = try awaitCompletion(of: urlSession.publisher(for: request, using: Void()))
        XCTAssertFalse(result.isEmpty)
    }

    func testFailsIfCannotDecodeResponse() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Public, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let responder: UrlProtocolMock = .init()
        UrlProtocolMock.data = Data()
        let urlSession: URLSession = URLSession(mockResponder: responder)
        XCTAssertThrowsError(try awaitCompletion(of: urlSession.publisher(for: request, using: Void())))
    }

    func testCanHandleHttpErrorCodes() throws {
        let request: NetworkRequest = NetworkRequest<NetworkRequestKinds.Public, ResponseStub>(
            endpoint: Endpoint(scheme: EndpointConfiguration.test.scheme, host: EndpointConfiguration.test.host),
            path: "endpoint")
        let responder: UrlProtocolMock = .init()
        for i in 403..<600 {
            UrlProtocolMock.statusCode = i
            UrlProtocolMock.data = try JSONEncoder().encode(ResponseStub())
            let urlSession: URLSession = URLSession(mockResponder: responder)
            XCTAssertThrowsError(try awaitCompletion(of: urlSession.publisher(for: request, using: Void())))
        }
    }
}
