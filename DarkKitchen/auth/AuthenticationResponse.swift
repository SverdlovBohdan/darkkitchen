//
//  AuthResponse.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 13.11.2021.
//

import Foundation

struct AuthenticationResponse: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
