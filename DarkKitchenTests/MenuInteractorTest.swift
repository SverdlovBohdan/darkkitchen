//
//
//  Created by Bohdan Sverdlov on 22.10.2021.
//

import XCTest
import Combine
import SwiftUI

@testable import DarkKitchen

class MenuInteractorTest: XCTestCase {
    var menuRepository: ProductsRepositoryStub!
    var menu: MenuInteractor!

    var expectation: XCTestExpectation!
    var expectedStates: [MenuState]!
    var incomingStates: [MenuState]!
    var appState: AppState = AppState()
    var categories: ProductCategories {
        return (0..<10).compactMap { id in
            ProductCategory(id: id, name: "\(id)")
        }
    }
    var menuItems: Products {
        categories.compactMap { category in
            return Product(name: "", price: 0, description: "",
                        category: category, main_image: .init(url: ""))
        }
    }

    func configure(categories: AnyPublisher<ProductCategories, Error>,
                   products: AnyPublisher<Products, Error>,
                   setStateHandler: @escaping (AppState) -> Void) {
        menuRepository.getCategoriesPublisher = categories
        menuRepository.getProductsPublisher = products

        menu = MenuInteractor(menuRepository: menuRepository)
        menu.getFullMenu(appStateHolder: .init(get: {
            return self.appState
        }, set: setStateHandler))
    }

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        expectedStates = .init()
        incomingStates = .init()
        menuRepository = ProductsRepositoryStub()
        menu = MenuInteractor(menuRepository: menuRepository)
    }

    override func tearDownWithError() throws {
    }

    func testCanRetrieveFullMenu() throws {
        configure(categories: Just(categories)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher(),
                  products: Just(menuItems)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher(),
                  setStateHandler: { state in
            switch state.userData.fullMenuState {
            case .loaded(_):
                print("\(state.userData.fullMenuState)")
                self.expectation.fulfill()
            default:
                print("\(state.userData.fullMenuState)")
            }

            self.appState = state
        })

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(menuRepository.categories, categories.compactMap({ category in
            return category.id
        }))
    }

    func testSetsFailedMenuStateIfUnableToGetCategories() throws {
        configure(categories: Fail(error: NetworkError.unknown)
                    .eraseToAnyPublisher(),
                  products: Just(menuItems)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher(),
                  setStateHandler: { state in
            switch state.userData.fullMenuState {
            case .failed(let _):
                print("\(state.userData.fullMenuState)")
                self.expectation.fulfill()
            default:
                print("\(state.userData.fullMenuState)")
            }

            self.appState = state
        })

        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(menuRepository.categories.isEmpty)
    }
}
