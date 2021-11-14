//
//  TokenState+Equatable.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 14.11.2021.
//

import Foundation
@testable import DarkKitchen

extension TokenState: Equatable {
    public static func == (lhs: TokenState, rhs: TokenState) -> Bool {
        return lhs.description == rhs.description
    }
}
