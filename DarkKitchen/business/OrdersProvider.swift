//
//  OrdersProvider.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 27.10.2021.
//

import Foundation
import SwiftUI

protocol OrdersProvider {
    func getOrders(ordersStateHolder ordersState: Binding<OrdersState>)
}
