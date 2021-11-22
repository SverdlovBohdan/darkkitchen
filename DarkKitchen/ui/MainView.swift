//
//  ContentView.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 19.09.2021.
//

import SwiftUI

struct MainView: View {
    @Injected(\.tokenReader) var tokenReader: TokenReader
    @Injected(\.profileProvider) var profileProvider: ProfileProvider
    @Injected(\.productsProvider) var menuProvider: MenuProvider

    @EnvironmentObject var appState: AppState
    @State private var selectedTab: String = "Меню"

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MenuView(categories: .init())
                    .tabItem {
                        Image(systemName: "menucard")
                        Text("Меню")
                    }
                    .tag("Меню")
                Text("Заказ")
                    .tabItem {
                        Image(systemName: "bag")
                        Text("Заказ")
                    }
                    .tag("Заказ")
                Text("История")
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("История")
                    }
                    .tag("История")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        makeProfileIcon()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(selectedTab)
                        .font(.system(size: 45, weight: .bold, design: .default))
                }
            }
            .onAppear {
                tokenReader.readToken(to: $appState.tokenState)
                menuProvider.getFullMenu(categoriesStateHolder: $appState.categoriesState,
                                         menuStateHolder: $appState.fullMenuState)
            }
        }
        .accentColor(Color("MainBlue"))
    }
}

private extension MainView {
    @ViewBuilder func makeProfileIcon() -> some View {
        if appState.profileState.isProcessing {
            ProgressView()
        } else if appState.profileState.isIdle && appState.tokenState.isTokenExist {
            ProgressView()
                .onAppear {
                    profileProvider
                        .getCurrentProfile(profileStateHolder: $appState.profileState)
                }
        } else if let _ = appState.profileState.resource {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
        } else {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var appState: AppState = {
        let appState = AppState()
        GlobalObjectsContainer.injectDevelopmentEnvironment(appState: appState)
        InjectedValues[\.tokenRepository].setToken("test token")
        return appState
    }()

    static var previews: some View {
        MainView()
            .environmentObject(appState)
    }
}
