//
//  ProfileInteractor.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI
import Combine

class ProfileInteractor: ProfileProvider {
    private let profileRepository: ProfileRepository
    private let accountRepository: AccountRepository

    var cancellable: Set<AnyCancellable> = .init()

    init(profileRepository: ProfileRepository,
         accountRepository: AccountRepository) {
        self.profileRepository = profileRepository
        self.accountRepository = accountRepository
    }

    func getCurrentProfile(profileStateHolder state: Binding<ProfileState>) {
        state.wrappedValue = ProfileState.processing

        profileRepository.loadProfile()
            .print()
            .tryCatch { error in
                return self.accountRepository.getAccountInfo()
                    .flatMap { user in
                        return self.profileRepository.saveProfile(for: user)
                    }
            }
            .map { user in
                ProfileState.loaded(.init(user: user))
            }
            .catch { error in
                return Just(ProfileState.loadFailed(error))
            }
            .receive(on: RunLoop.main)
            .sink { newState in
                state.wrappedValue = newState
            }
            .store(in: &cancellable)
    }
}
