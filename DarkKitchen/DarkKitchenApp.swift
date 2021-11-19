//
//  DarkKitchenApp.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 19.09.2021.
//

import SwiftUI

@main
struct DarkKitchenApp: App {
    static var globals: GlobalObjectsContainer = {
        GlobalObjectsContainer.development.tokenRepository.setToken("1234")
        return GlobalObjectsContainer.development
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(DarkKitchenApp.globals.appState)
                .environment(\.globalObjects, DarkKitchenApp.globals)
        }
    }
}
