//
//  AppStateTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 28.10.2021.
//

import XCTest
@testable import DarkKitchen

class AppStateTest: XCTestCase {
    var appState: AppState!

    override func setUpWithError() throws {
        appState = AppState()
    }

    override func tearDownWithError() throws {
    }

    func testAppStateCreationSetsValidStates() throws {
        XCTAssertEqual(appState.userData.pushOrderState, .idle)
        XCTAssertEqual(appState.userData.ordersState, .idle)
        XCTAssertEqual(appState.userData.fullMenuState, .idle)
    }
}