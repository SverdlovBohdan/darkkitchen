//
//  Category.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 11.11.2021.
//

import Foundation

struct ItemCategory: Codable {
    var id: Int
    var name: String
}

typealias ItemCategories = [ItemCategory]
