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
    _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
    return { state, action, environment in
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
        
        return reducer(&state, action, environment)
    }
}

func createAppReducer() -> Reducer<AppState, AppAction, AppEnvironment> {
    
    let reducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
        pullback(counterViewReducer,
                 value: \.counterView,
                 action: \.counterView,
                 environment: { ($0.nthPrime, $0.log) } ),
        pullback(favoritePrimesReducer,
                 value: \.favoritePrimes,
                 action: \.favoritePrimes,
                 environment: { $0.fileClient })
    )
    
    return logging(activityFeed(reducer), logger: { _ in { toLog in print(toLog) }})
}

