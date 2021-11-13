//
//  Category.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 11.11.2021.
//

import Foundation

struct ProductCategory: Codable {
    var id: Int
    var name: String
}

typealias ProductCategories = [ProductCategory]
