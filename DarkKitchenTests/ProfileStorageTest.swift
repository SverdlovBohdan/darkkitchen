//
//  ProfileStorageTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

import XCTest
@testable import DarkKitchen

class ProfileStorageTest: XCTestCase {
    var storage: ProfileStorage!
    var user: Client = .init(name: "", phone: "", email: "", mainAddress: "")

    override func setUpWithError() throws {
        storage = ProfileStorage()
        storage.cleanUp()
    }

    override func tearDownWithError() throws {
    }

    func testCanSaveProfile() throws {
        XCTAssertNoThrow(try awaitCompletion(of: storage.saveProfile(for: user)))
    }

    func testCanLoadProfile() throws {
        XCTAssertNoThrow(try awaitCompletion(of: storage.saveProfile(for: user)))
        let result = try awaitCompletion(of: storage.loadProfile())[0]
        XCTAssertEqual(user.name, result.name)
    }

    func testFailsIfNoPersistedUser() throws {
        XCTAssertThrowsError(try awaitCompletion(of: storage.loadProfile()))
    }

    func testFailsIfCantDecodeProfile() throws {
        storage.saveCustomString("1234")
        XCTAssertThrowsError(try awaitCompletion(of: storage.loadProfile()))
    }
}
