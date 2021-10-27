//
//  Interactors.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation
import SwiftUI

public struct InteractorsContainer {
//    let menuInteractor: MenuInteractor
//    let cartInteractor: CartInteractor
//    let profileInteractor: ProfileInteractor
//    let orderInteractor: OrderInteractor
}

private struct Interactors: EnvironmentKey {
    static let defaultValue: InteractorsContainer = InteractorsContainer()
}

public extension EnvironmentValues {
    var interactors: InteractorsContainer {
        get { self[Interactors.self] }
        set { self[Interactors.self] = newValue }
    }
}
