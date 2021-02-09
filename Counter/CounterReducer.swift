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
    case nthPrimeResponse(Int?)
    case nthPrimeButtonTapped
    case alertDismissButtonTapped
}

public let counterViewReducer: (inout CounterViewState, CounterViewAction) -> [Effect<CounterViewAction>] = combine(
    pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
    pullback(primeModalReducer, value: \.primeModalViewState, action: \.primeModal)
)

public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
    switch action {
    case .decrTapped:
        state.count -= 1
        return []
    case .incrTapped:
        state.count += 1
        return []
    case .nthPrimeButtonTapped:
        state.isNthPrimeButtonDisabled = true
        return [{ [count = state.count] callback in
            WebRequestsService().nthPrime(count) { (prime) in
                DispatchQueue.main.async {
                    callback(.nthPrimeResponse(prime))
                }
            }
        }]
    case let .nthPrimeResponse(prime):
        state.alertNthPrime = prime.map(PrimeAlert.init)
        state.isNthPrimeButtonDisabled = false
        return []
    case .alertDismissButtonTapped:
        state.alertNthPrime = nil
        return []
    }
    
    
}
