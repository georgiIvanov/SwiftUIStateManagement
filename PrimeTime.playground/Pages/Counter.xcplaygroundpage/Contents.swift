import ComposableArchitecture
import FavoritePrimes
import SwiftUI
import PlaygroundSupport
import PrimeModal
import Counter

PlaygroundPage.current.liveView = UIHostingController(
    rootView: CounterView(
        store: Store<CounterViewState, CounterViewAction>(
            initialValue: CounterViewState(
                count: 1_000_000,
                favoritePrimes: [5]
            ),
            reducer: counterViewReducer
        )
    )
)
