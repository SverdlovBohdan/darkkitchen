//
//  RepositoryActionState+Equatable.swift
//  DarkKitchenTests
//
//  Created by Bohdan Sverdlov on 23.10.2021.
//

import Foundation
@testable import DarkKitchen

extension Loadable : Equatable {
    public static func == (lhs: Loadable<Resource>, rhs: Loadable<Resource>) -> Bool {
        return lhs.description == rhs.description
    }
}
