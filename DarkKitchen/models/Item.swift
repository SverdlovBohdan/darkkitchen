//
//  Item.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation

struct Item: Codable {
    struct ImageUrl: Codable {
        var url: String
    }

    var name: String
    var price: Int
    var description: String

    var category: ItemCategory
    var main_image: ImageUrl
}

typealias MenuItems = [Item]
