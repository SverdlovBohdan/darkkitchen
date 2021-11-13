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
}
