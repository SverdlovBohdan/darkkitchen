//
//  Movable.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

/// State wrapper for resource which can be pushed or loaded.
enum Movable<Resource> {
    case idle
    case processing
    case loaded(Resource)
    case pushed
    case loadFailed(Error)
    case pushFailed(Error, Resource)
}

extension Movable: CustomStringConvertible {
    var description: String {
        switch self {
        case .idle:
            return "idle"
        case .processing:
            return "processing"
        case .loaded(_):
            return "loaded"
        case .pushed:
            return "pushed"
        case .loadFailed(_):
            return "load failed"
        case .pushFailed(_, _):
            return "push failed"
        }
    }

    var isIdle: Bool {
        switch self {
        case .idle:
            return true
        default:
            return false
        }
    }

    var isProcessing: Bool {
        switch self {
        case .processing:
            return true
        default:
            return false
        }
    }

    var isError: Bool {
        switch self {
        case .loadFailed(_), .pushFailed(_, _):
            return true
        default:
            return false
        }
    }

    var resource: Resource? {
        switch self {
        case .loaded(let resource):
            return resource
        default:
            return nil
        }
    }
}
