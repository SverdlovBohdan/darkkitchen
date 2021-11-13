//
//  Authentication.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

protocol Authentication {
    func logIn(name: String, password: String)
    func logOut()
}
