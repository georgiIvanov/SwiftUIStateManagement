//
//  FavoritePrimesReducer.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) {
    switch action {
    case .deleteFavoritePrimes(let indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}
