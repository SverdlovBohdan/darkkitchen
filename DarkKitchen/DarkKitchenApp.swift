//
//  DarkKitchenApp.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 19.09.2021.
//

import SwiftUI

@main
struct DarkKitchenApp: App {
    var appState: AppState = {
        let appState = AppState()
        GlobalObjectsContainer.injectDevelopmentEnvironment(appState: appState)
        InjectedValues[\.tokenRepository].setToken("test token")
        return appState
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
