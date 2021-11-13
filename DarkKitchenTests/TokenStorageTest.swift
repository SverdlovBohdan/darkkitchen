//
//  TokenStorageTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import XCTest
@testable import DarkKitchen

class TokenStorageTest: XCTestCase {
    var storage: TokenStorage!

    override func setUpWithError() throws {
        storage = TokenStorage()
        storage.cleanUp()
    }

    override func tearDownWithError() throws {
    }

    func testCanSaveToken() throws {
        XCTAssertNoThrow(try awaitCompletion(of: storage.setToken("1234")))
    }

    func testCanGetToken() throws {
        XCTAssertNoThrow(try awaitCompletion(of: storage.setToken("1234")))
        let result = try awaitCompletion(of: storage.getToken())[0]
        XCTAssertEqual("1234", result)
    }

    func testFailsIfNoPersistedToken() throws {
        XCTAssertThrowsError(try awaitCompletion(of: storage.getToken()))
    }
}
