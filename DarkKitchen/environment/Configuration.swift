//
//  Configuration.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 31.10.2021.
//

import Foundation

struct Configuration {
    enum Kind {
        case development
        case staging
        case production
    }

    var kind: Kind

    var host: String {
        switch kind {
        case .development:
            return "127.0.0.1"
        case .staging:
            return "127.0.0.1"
        case .production:
            return "127.0.0.1"
        }
    }
}
