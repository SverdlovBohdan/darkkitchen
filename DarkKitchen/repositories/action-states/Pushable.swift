//
//  Pushable.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 27.10.2021.
//

import Foundation

enum Pushable<Resource> {
    case idle
    case pushing(Resource)
    case pushed
    case failed(Error, Resource)
}

extension Pushable: CustomStringConvertible {
    var description: String {
        switch self {
        case .idle:
            return "idle"
        case .pushing(_):
            return "pushing"
        case .pushed:
            return "loaded"
        case .failed(_, _):
            return "failed"
        }
    }
}
