//
//  OrderInteractorCombine.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 27.10.2021.
//

import Foundation
import Combine

protocol CombineInteractor: AnyObject {
    associatedtype Repository

    var repository: Repository { get }
    var cancellable: Set<AnyCancellable> { get set }
}
