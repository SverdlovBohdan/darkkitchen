//
//  AppState.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var userData: UserData = UserData(fullMenuState: .idle,
                                                 ordersState: .idle,
                                                 pushOrderState: .idle,
                                                 categoriesState: .idle)
}
