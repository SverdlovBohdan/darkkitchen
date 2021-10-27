//
//
//  Created by Bohdan Sverdlov on 22.10.2021.
//

import XCTest
import SwiftUI

@testable import DarkKitchen

class MenuTest: XCTestCase {
    var menuRepository: MenuRepositoryStub!
    var menu: MenuInteractor!

    var expectation: XCTestExpectation!
    var expectedStates: [MenuState]!
    var incomingStates: [MenuState]!
    var menuState: MenuState!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        expectedStates = .init()
        incomingStates = .init()
        menuState = .idle
    }

    override func tearDownWithError() throws {
    }

    func testCanRetrieveFullMenu() throws {
        menuRepository = MenuRepositoryStub()
        menu = MenuInteractor(menuRepository: menuRepository)

        menu.getFullMenu(menuStateHolder: .init(get: {
            self.menuState
        }, set: { newState in
            switch newState {
            case .loaded(_):
                print("\(newState)")
                self.incomingStates.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingStates.append(newState)
            }
            self.menuState = newState
        }))

        wait(for: [expectation], timeout: 10.0)

        expectedStates = [.loading, .loaded(menuRepository.items)]
        XCTAssertEqual(expectedStates, incomingStates)
    }

    func testGetsFailedMenuStateIfUnableToGetFullMenu() {
        menuRepository = MenuRepositoryStub()
        menuRepository.behavior = .failedToGetFullMenu
        menu = MenuInteractor(menuRepository: menuRepository)

        menu.getFullMenu(menuStateHolder: .init(get: {
            self.menuState
        }, set: { newState in
            switch newState {
            case .failed(_):
                print("\(newState)")
                self.incomingStates.append(newState)
                self.expectation.fulfill()
            default:
                print("\(newState)")
                self.incomingStates.append(newState)
            }
            self.menuState = newState
        }))

        wait(for: [expectation], timeout: 10.0)

        expectedStates = [.loading, .failed(RepositoryError.RetrieveDataError)]
        XCTAssertEqual(expectedStates, incomingStates)
    }
}
