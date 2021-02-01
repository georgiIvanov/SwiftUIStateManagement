//
//  Reducers.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 25.01.21.
//

import Foundation
import ComposableArchitecture
import FavoritePrimes
import PrimeModal
import Counter

func activityFeed(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        switch action {
        case .counter:
            break
        case .primeModal(.removeFavoritePrimeTapped):
            state.activityFeed.append(.init(timestamp: Date(),
                                            type: .removedFavoritePrime(state.count)))
        case .primeModal(.saveFavoritePrimeTapped):
            state.activityFeed.append(.init(timestamp: Date(),
                                            type: .addedFavoritePrime(state.count)))
        case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
            for index in indexSet {
                let prime = state.favoritePrimes[index]
                state.activityFeed.append(.init(timestamp: Date(),
                                                type: .removedFavoritePrime(prime)))
            }
        }
        
        reducer(&state, action)
    }
}

func createAppReducer() -> (inout AppState, AppAction) -> Void {
    let reducer: (inout AppState, AppAction) -> Void = combine(
        pullback(counterReducer, value: \.count, action: \.counter),
        pullback(primeModalReducer, value: \.primeModal, action: \.primeModal),
        pullback(favoritePrimesReducer, value: \.favoritePrimes, action: \.favoritePrimes)
    )
    
    return activityFeed(reducer)
}

