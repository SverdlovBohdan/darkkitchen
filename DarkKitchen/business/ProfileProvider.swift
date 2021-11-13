//
//  ProfileProvider.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation
import SwiftUI

protocol ProfileProvider {
    func getCurrentProfile(profileStateHolder state: Binding<ProfileState>)
}
