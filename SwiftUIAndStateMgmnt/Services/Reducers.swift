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
import CasePaths

func activityFeed(
    _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
    return { state, action, environment in
        switch action {
        case .counterView(.counter),
             .offlineCounterView(.counter),
             .favoritePrimes(.loadedFavoritePrimes),
             .favoritePrimes(.saveButtonTapped),
             .favoritePrimes(.loadButtonTapped),
             .favoritePrimes(.primeButtonWasTapped(_)),
             .favoritePrimes(.nthPrimeResponse(_, _)),
             .favoritePrimes(.alertDismissButtonTapped):
            break
        case .counterView(.primeModal(.removeFavoritePrimeTapped)),
             .offlineCounterView(.primeModal(.removeFavoritePrimeTapped)):
            state.activityFeed.append(.init(timestamp: Date(),
                                            type: .removedFavoritePrime(state.count)))
        case .counterView(.primeModal(.saveFavoritePrimeTapped)),
             .offlineCounterView(.primeModal(.saveFavoritePrimeTapped)):
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
                 action: /AppAction.counterView,
                 environment: { ($0.nthPrime, $0.log) } ),
        pullback(counterViewReducer,
                 value: \.counterView,
                 action: /AppAction.offlineCounterView,
                 environment: { ($0.offlineNthPrime, $0.log) } ),
        pullback(favoritePrimesReducer,
                 value: \.favoritePrimesState,
                 action: /AppAction.favoritePrimes,
                 environment: { ($0.fileClient, $0.nthPrime) })
    )
    
    // Using logger on integration tests causes them to fail
    // there are effects froduced and assert is not equipped to handle them
    // TODO: remove logging in unit tests - https://stackoverflow.com/questions/27500940/how-to-let-the-app-know-if-its-running-unit-tests-in-a-pure-swift-project
//    logging(activityFeed(reducer), logger: { _ in { toLog in print(toLog) }})
    return activityFeed(reducer)
}

