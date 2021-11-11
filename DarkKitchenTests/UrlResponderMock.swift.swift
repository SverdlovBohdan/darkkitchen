//
//  UrlResponderMock.swift.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 08.11.2021.
//

import Foundation
import XCTest

class UrlProtocolMock: URLProtocol {
    static var data: Data = .init()
    static var statusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
            // Here we try to get data from our responder type, and
            // we then send that data, as well as a HTTP response,
            // to our client. If any of those operations fail,
            // we send an error instead:
            let data = UrlProtocolMock.data
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: UrlProtocolMock.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))

            client.urlProtocol(self,
                               didReceive: response,
                               cacheStoragePolicy: .notAllowed
            )
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}

extension URLSession {
    convenience init(mockResponder: UrlProtocolMock) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [UrlProtocolMock.self]
        self.init(configuration: config)
        URLProtocol.registerClass(UrlProtocolMock.self)
    }
}
