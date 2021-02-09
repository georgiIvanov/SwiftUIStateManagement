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
    _ reducer: @escaping (inout AppState, AppAction) -> [Effect<AppAction>]
) -> (inout AppState, AppAction) -> [Effect<AppAction>] {
    return { state, action in
        switch action {
        case .counterView(.counter),
             .favoritePrimes(.loadedFavoritePrimes),
             .favoritePrimes(.saveButtonTapped),
             .favoritePrimes(.loadButtonTapped):
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
        
        return reducer(&state, action)
    }
}

func createAppReducer() -> (inout AppState, AppAction) -> [Effect<AppAction>] {
    let reducer: (inout AppState, AppAction) -> [Effect<AppAction>] = combine(
        pullback(counterViewReducer, value: \.counterView, action: \.counterView),
        pullback(favoritePrimesReducer, value: \.favoritePrimes, action: \.favoritePrimes)
    )
    
    return logging(activityFeed(reducer))
}

