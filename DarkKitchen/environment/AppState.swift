//
//  AppState.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

class AppState: ObservableObject, TokenProvidable {
    @Published var userData: UserData = UserData(fullMenuState: .idle,
                                                 ordersState: .idle,
                                                 pushOrderState: .idle,
                                                 categoriesState: .idle,
                                                 tokenState: .absent,
                                                 profileState: .idle)

    var token: String? {
        switch userData.tokenState {
        case .absent:
            return nil
        case .exist(let token):
            return token
        }
    }
}
