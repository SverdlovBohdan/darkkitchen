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
}
