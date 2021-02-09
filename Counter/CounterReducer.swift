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
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
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
        return [{ [count = state.count] in
            var resultNumber: Int?
            let semaphore = DispatchSemaphore(value: 0)
            WebRequestsService().nthPrime(count) { (prime) in
                resultNumber = prime
                semaphore.signal()
            }
            
            semaphore.wait()
            
            return .nthPrimeResponse(resultNumber)
        }]
    case let .nthPrimeResponse(prime):
        state.alertNthPrime = prime.map(PrimeAlert.init)
        state.isNthPrimeButtonDisabled = false
        return []
    }
    
    
}
