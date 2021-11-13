//
//  TokenReader.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import SwiftUI

protocol TokenReader {
    func readToken(to state: Binding<TokenState>)
}
