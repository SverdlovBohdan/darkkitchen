//
//  RepositoryError.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 22.10.2021.
//

import Foundation

enum RepositoryError: Error {
    case RetrieveDataError
    case DecodeDataError
    case PushDataError
}
