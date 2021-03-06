//
//  Counter.swift
//  Reducers
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture
import PrimeModal
import Combine
import PrimeAlert
import CasePaths

public enum CounterAction: Equatable {
    case decrTapped
    case incrTapped
    case isPrimeButtonTapped
    case primeModalDismissed
    case nthPrimeResponse(Int?)
    case nthPrimeButtonTapped
    case alertDismissButtonTapped
}

public let counterViewReducer: Reducer<CounterFeatureState, CounterFeatureAction, CounterEnvironment> = combine(
    pullback(counterReducer,
             value: \CounterFeatureState.counter,
             action: /CounterFeatureAction.counter,
             environment: { $0 }),
    pullback(primeModalReducer,
             value: \.primeModalViewState,
             action: /CounterFeatureAction.primeModal,
             environment: { _ in () })
)

public func counterReducer(state: inout CounterState,
                           action: CounterAction,
                           environment: CounterEnvironment) -> [Effect<CounterAction>] {
    switch action {
    case .decrTapped:
        state.count -= 1
        return []
    case .incrTapped:
        state.count += 1
        return []
    case .isPrimeButtonTapped:
        state.isPrimeModalShown = true
        return []
    case .primeModalDismissed:
        state.isPrimeModalShown = false
        return []
    case .nthPrimeButtonTapped:
        state.isNthPrimeButtonDisabled = true
        return [
            environment.nthPrime(state.count)
                .map(CounterAction.nthPrimeResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        ]
    case let .nthPrimeResponse(prime):
        state.alertNthPrime = prime.map { PrimeAlert.init(n: state.count, prime: $0) }
        state.isNthPrimeButtonDisabled = false
        return []
    case .alertDismissButtonTapped:
        state.alertNthPrime = nil
        return []
    }
}
