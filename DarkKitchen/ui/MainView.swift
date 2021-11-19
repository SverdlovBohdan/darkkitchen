//
//  ContentView.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 19.09.2021.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Color("MainPink")
                .ignoresSafeArea()

            Text("Меню")
        }
    }
}

struct MainView: View {
    @Environment(\.globalObjects) var globals: GlobalObjectsContainer
    @EnvironmentObject var appState: AppState

    @State private var selectedTab: String = "Меню"

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MenuView()
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
                        if appState.profileState.isProcessing {
                            ProgressView()
                        } else if appState.profileState.isIdle && appState.tokenState.isTokenExist {
                            ProgressView()
                                .onAppear {
                                    globals.profileInteractor
                                        .getCurrentProfile(profileStateHolder: $appState.profileState)
                                }
                        } else if let _ = appState.profileState.resource {
                            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        } else {
                            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(selectedTab)
                        .font(.system(size: 45, weight: .bold, design: .default))
                }
            }
            .onAppear {
                globals.authInteractor.readToken(to: $appState.tokenState)
            }
        }
        .accentColor(Color("MainBlue"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var globals: GlobalObjectsContainer = {
        GlobalObjectsContainer.development.tokenRepository.setToken("1234")
        return GlobalObjectsContainer.development
    }()

    static var previews: some View {
        MainView()
            .environmentObject(globals.appState)
            .environment(\.globalObjects, globals)
    }
}
