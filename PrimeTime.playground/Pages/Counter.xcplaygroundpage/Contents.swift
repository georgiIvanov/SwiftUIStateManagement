import ComposableArchitecture
import SwiftUI
import PlaygroundSupport
@testable import Counter

var environment = (mockNthPrime, mockLog)

PlaygroundPage.current.liveView = UIHostingController(
    rootView: CounterView(
        store: Store<CounterFeatureState, CounterFeatureAction>(
            initialValue: CounterFeatureState(
                count: 5,
                favoritePrimes: [5],
                alertNthPrime: nil,
                isNthPrimeButtonDisabled: false
            ),
            reducer: logging(counterViewReducer,
                             logger: { $0.log }),
            environment: environment
        )
    )
)
