//
//  Pushable+Equatable.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 27.10.2021.
//

import Foundation
@testable import DarkKitchen

extension Pushable : Equatable {
    public static func == (lhs: Pushable<Resource>, rhs: Pushable<Resource>) -> Bool {
        return lhs.description == rhs.description
    }
}
