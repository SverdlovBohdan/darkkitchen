//
//  FullMenuProvider.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 23.10.2021.
//

import Foundation
import SwiftUI

protocol MenuProvider {
    func getFullMenu(appStateHolder appState: Binding<AppState>)
}
