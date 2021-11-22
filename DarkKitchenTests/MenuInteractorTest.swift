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
                   setStateHandler: @escaping (MenuState) -> Void) {
        menuRepository.getCategoriesPublisher = categories
        menuRepository.getProductsPublisher = products

        menu = MenuInteractor(menuRepository: menuRepository)
        menu.getFullMenu(categoriesStateHolder: .constant(appState.categoriesState)
                         , menuStateHolder:.init(get: {
            return self.appState.fullMenuState
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
            switch state {
            case .loaded(_):
                print("\(state)")
                self.expectation.fulfill()
            default:
                print("\(state)")
            }

            self.appState.fullMenuState = state
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
            switch state {
            case .failed(_):
                print("\(state)")
                self.expectation.fulfill()
            default:
                print("\(state)")
            }

            self.appState.fullMenuState = state
        })

        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(menuRepository.categories.isEmpty)
    }

    func testSetsFailedMenuStateIfUnableToGetProducts() throws {
        configure(categories: Just(categories)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher(),
                  products: Fail(error: NetworkError.unknown)
                    .eraseToAnyPublisher(),
                  setStateHandler: { state in
            switch state {
            case .failed(_):
                print("\(state)")
                self.expectation.fulfill()
            default:
                print("\(state)")
            }

            self.appState.fullMenuState = state
        })

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(menuRepository.categories, categories.compactMap({ category in
            return category.id
        }))
    }
}
