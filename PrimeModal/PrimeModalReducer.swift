//
//  PrimeModal.swift
//  Reducers
//
//  Created by Voro on 1.02.21.
//

import Foundation

public enum PrimeModalAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}


public func primeModalReducer(state: inout PrimeModalViewState, action: PrimeModalAction) {
    switch action {
    case .saveFavoritePrimeTapped:
        state.favoritePrimes.append(state.count)
    case .removeFavoritePrimeTapped:
        state.favoritePrimes.removeAll { $0 == state.count }
    }
}
