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
        XCTAssertEqual(appState.pushOrderState, .idle)
        XCTAssertEqual(appState.ordersState, .idle)
        XCTAssertEqual(appState.fullMenuState, .idle)
        XCTAssertEqual(appState.tokenState, .absent)
        XCTAssertEqual(appState.categoriesState, .idle)
        XCTAssertEqual(appState.profileState, .idle)
    }
}
