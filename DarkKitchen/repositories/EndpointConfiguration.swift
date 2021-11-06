//
//  EndpointConfiguration.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 06.11.2021.
//

import Foundation

struct EndpointConfiguration {
    let scheme: String
    let host: String

    var fullEndpoint: String {
        return "\(scheme)://\(host)"
    }
}

extension EndpointConfiguration {
    static let test: Self =
        EndpointConfiguration(scheme: "http", host: "127.0.0.1")
}
