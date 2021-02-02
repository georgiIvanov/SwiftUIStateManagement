//
//  Reducers.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 25.01.21.
//

import Foundation
import ComposableArchitecture
import FavoritePrimes
import Counter

func activityFeed(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        switch action {
        case .counterView(.counter):
            break
        case .counterView(.primeModal(.removeFavoritePrimeTapped)):
            state.activityFeed.append(.init(timestamp: Date(),
                                            type: .removedFavoritePrime(state.count)))
        case .counterView(.primeModal(.saveFavoritePrimeTapped)):
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
        pullback(counterViewReducer, value: \.counterView, action: \.counterView),
        pullback(favoritePrimesReducer, value: \.favoritePrimes, action: \.favoritePrimes)
    )
    
    return activityFeed(reducer)
}

