//
//  FullMenuProvider.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 23.10.2021.
//

import Foundation
import SwiftUI

protocol MenuProvider {
    func getFullMenu(categoriesStateHolder categoriesState: Binding<CategoriesState>,
                     menuStateHolder productsState: Binding<MenuState>)
}
