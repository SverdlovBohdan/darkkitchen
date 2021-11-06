//
//  NetworkRequestTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 04.11.2021.
//

import XCTest
@testable import DarkKitchen

struct ResponseStub: Decodable {}

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
}
