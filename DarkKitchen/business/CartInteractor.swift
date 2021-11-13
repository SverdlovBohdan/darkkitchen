//
//  CartInteractor.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

protocol CartInteractor {
    func addIntem(appState: Binding<AppState>, item: Product)
    func removeItem(appState: Binding<AppState>, item: Product)
    func clear(appState: Binding<AppState>)
}
