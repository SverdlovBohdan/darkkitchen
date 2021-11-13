//
//  AuthenticationState.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

enum TokenState {
    case exist(token: String)
    case absent
}

typealias UserState = Loadable<Client>
typealias ProfileState = Movable<Profile>
