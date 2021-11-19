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
    var isTokenExist: Bool {
        switch self {
        case .exist(_):
            return true
        default:
            return false
        }
    }

    var token: String? {
        switch self {
        case .exist(let token):
            return token
        default:
            return nil
        }
    }

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
