//
//  AppState.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

class AppState: ObservableObject, TokenProvidable {
    @Published var fullMenuState: MenuState = .idle
    @Published var ordersState: OrdersState = .idle
    @Published var pushOrderState: PushOrderState = .idle
    @Published var categoriesState: CategoriesState = .idle
    @Published var tokenState: TokenState = .absent
    @Published var profileState: ProfileState = .idle
    
    var token: String? {
        switch tokenState {
        case .exist(let token):
            return token
        case .absent:
            return nil
        }
    }
}
