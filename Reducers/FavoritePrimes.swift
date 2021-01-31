//
//  FavoritePrimes.swift
//  Reducers
//
//  Created by Voro on 1.02.21.
//

import Foundation

public enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)

    var deleteFavoritePrimes: IndexSet? {
        get {
            guard case let .deleteFavoritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .deleteFavoritePrimes = self, let newValue = newValue else { return }
            self = .deleteFavoritePrimes(newValue)
        }
    }
}

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) {
    switch action {
    case .deleteFavoritePrimes(let indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}
