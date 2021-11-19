//
//  TokenState+Equatable.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 14.11.2021.
//

import Foundation
@testable import DarkKitchen

extension Movable: Equatable {
    public static func == (lhs: Movable<Resource>, rhs: Movable<Resource>) -> Bool {
        return lhs.description == rhs.description
    }
}
