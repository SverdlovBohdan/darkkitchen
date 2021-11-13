//
//  Item.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 21.09.2021.
//

import Foundation

struct Product: Codable {
    struct ImageUrl: Codable {
        var url: String
    }

    var name: String
    var price: Int
    var description: String

    var category: ProductCategory
    var main_image: ImageUrl
}

typealias Products = [Product]
