//
//  ProfileInteractorTest.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 14.11.2021.
//

import Foundation

import XCTest
import Combine
@testable import DarkKitchen

class ProfileInterfactorTest: XCTestCase {
    var profileRepository: ProfileRepositoryStub!
    var accountRepository: AccountRepositoryStub!
    var interactor: ProfileInteractor!

    var profileState: ProfileState = .idle
    var cachedProfile: Client = .init(name: "cached", phone: "", email: "", mainAddress: "")
    var remoteProfile: Client = .init(name: "remote", phone: "", email: "", mainAddress: "")

    var expectation: XCTestExpectation!

    func getProfile(accountInfoPublisher: AnyPublisher<Client, Error>,
                    savePublisher: AnyPublisher<Client, Error>,
                    loadPublisher: AnyPublisher<Client, Error>,
                    setStateHandler: @escaping (ProfileState) -> Void) {
        accountRepository.accountInfoPublisher = accountInfoPublisher
        profileRepository.loadPublisher = loadPublisher
        profileRepository.savePublisher = savePublisher

        interactor = ProfileInteractor(profileRepository: profileRepository,
                                       accountRepository: accountRepository)
        interactor.getCurrentProfile(profileStateHolder: .init(get: {
            return self.profileState
        }, set: setStateHandler))
    }

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        profileRepository = ProfileRepositoryStub()
        accountRepository = AccountRepositoryStub()
    }

    override func tearDownWithError() throws {
    }

    func testGetsCurrentProfileFromeCache() throws {
        getProfile(
            accountInfoPublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher(),
            savePublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher(),
            loadPublisher: Just(cachedProfile).setFailureType(to: Error.self).eraseToAnyPublisher()) { newState in
                switch newState {
                case .loaded(_):
                    print("\(newState)")
                    self.expectation.fulfill()
                default:
                    print("\(newState)")
                }

                self.profileState = newState
            }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(profileState.resource!.user.name, cachedProfile.name)
    }

    func testGetsCurrentProfileFromeNetwrokIfUnableToGetFromCache() throws {
        getProfile(
            accountInfoPublisher: Just(remoteProfile).setFailureType(to: Error.self).eraseToAnyPublisher(),
            savePublisher: Just(remoteProfile).setFailureType(to: Error.self).eraseToAnyPublisher(),
            loadPublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher()) { newState in
                switch newState {
                case .loaded(_):
                    print("\(newState)")
                    self.expectation.fulfill()
                default:
                    print("\(newState)")
                }

                self.profileState = newState
            }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(profileState.resource!.user.name, remoteProfile.name)
    }

    func testSavesProfileFromNetwork() throws {
        getProfile(
            accountInfoPublisher: Just(remoteProfile).setFailureType(to: Error.self).eraseToAnyPublisher(),
            savePublisher: Just(cachedProfile).setFailureType(to: Error.self).eraseToAnyPublisher(),
            loadPublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher()) { newState in
                switch newState {
                case .loaded(_):
                    print("\(newState)")
                    self.expectation.fulfill()
                default:
                    print("\(newState)")
                }

                self.profileState = newState
            }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(profileState.resource!.user.name, cachedProfile.name)
    }

    func testFailsIfUnableToGetProfileFromNetwork() throws {
        getProfile(
            accountInfoPublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher(),
            savePublisher: Just(remoteProfile).setFailureType(to: Error.self).eraseToAnyPublisher(),
            loadPublisher: Fail(error: RepositoryError.ConvertError).eraseToAnyPublisher()) { newState in
                switch newState {
                case .loadFailed(_):
                    print("\(newState)")
                    self.expectation.fulfill()
                default:
                    print("\(newState)")
                }

                self.profileState = newState
            }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertNil(profileState.resource)
    }
}
