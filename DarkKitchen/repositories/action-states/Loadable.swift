//
//  MenuState.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 18.10.2021.
//

import Foundation

/// State wrapper for resource which can be loaded
enum Loadable<Resource> {
    case idle
    case loading
    case loaded(Resource)
    case failed(Error)
}

extension Loadable: CustomStringConvertible {
    var description: String {
        switch self {
        case .idle:
            return "idle"
        case .loading:
            return "loading"
        case .loaded(_):
            return "loaded"
        case .failed(_):
            return "failed"
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

    var isLoading: Bool {
        switch self {
        case .loading:
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

    var error: String? {
        switch self {
        case .failed(_):
            return "Опаньки. Произошла ошибка"
        default:
            return nil
        }
    }
}
