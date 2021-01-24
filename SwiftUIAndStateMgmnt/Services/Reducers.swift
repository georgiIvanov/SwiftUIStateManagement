//
//  Reducers.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 25.01.21.
//

import Foundation

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    get: @escaping (GlobalValue) -> LocalValue,
    set: @escaping (inout GlobalValue, LocalValue) -> Void
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        var localValue = get(globalValue)
        reducer(&localValue, action)
        set(&globalValue, localValue)
    }
}

func createAppReducer() -> (inout AppState, AppAction) -> Void {
    return combine(pullback(counterReducer(state:action:), get: { $0.count }, set: { $0.count = $1 }),
                   primeModalReducer(state:action:),
                   favoritePrimesReducer(state:action:))
}

func counterReducer(state: inout Int, action: AppAction) {
    switch action {
    case .counter(.decrTapped):
        state -= 1
    case .counter(.incrTapped):
        state += 1
    default:
        break
    }
}

func primeModalReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .primeModal(.saveFavoritePrimeTapped):
        state.favoritePrimes.append(state.count)
        state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
    case .primeModal(.removeFavoritePrimeTapped):
        state.favoritePrimes.removeAll { $0 == state.count }
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
    default:
        break
    }
}

func favoritePrimesReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .favoritePrimes(.deleteFavoritePrimes(let indexSet)):
        for index in indexSet {
            state.favoritePrimes.remove(at: index)
            state.activityFeed.append(.init(timestamp: Date(),
                                            type: .removedFavoritePrime(state.count)))
        }
    default:
        break
    }
}
