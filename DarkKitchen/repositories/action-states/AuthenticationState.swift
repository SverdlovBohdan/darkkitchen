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

extension TokenState: CustomStringConvertible {
    var description: String {
        switch self {
        case .absent:
            return "absent"
        case .exist(let token):
            return "exist \(token)"
        }
    }
}

typealias UserState = Loadable<Client>
typealias ProfileState = Movable<Profile>
