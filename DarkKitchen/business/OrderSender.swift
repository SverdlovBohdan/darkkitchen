//
//  OrderSender.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 27.10.2021.
//

import Foundation
import SwiftUI

protocol OrderSender {
    func sendOrder(pushOrderStateHolder pushOrderState: Binding<PushOrderState>, order: Order)
}
