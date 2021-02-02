//
//  Counter.swift
//  Reducers
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture
import PrimeModal

public enum CounterAction {
    case decrTapped
    case incrTapped
}

public let counterViewReducer: (inout CounterViewState, CounterViewAction) -> Void = combine(
    pullback(counterReducer, value: \CounterViewState.count, action: \CounterViewAction.counter),
    pullback(primeModalReducer, value: \.primeModalViewState, action: \.primeModal)
)

public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .decrTapped:
        state -= 1
    case .incrTapped:
        state += 1
    }
}
