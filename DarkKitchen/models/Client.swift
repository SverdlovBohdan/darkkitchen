//
//  User.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

struct Client: Codable {
    var name: String
    var phone: String
    var email: String
    var mainAddress: String

    private enum CodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case mainAddress = "main_address"
    }
}
