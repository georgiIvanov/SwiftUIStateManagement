import ComposableArchitecture
import FavoritePrimes
import SwiftUI
import PlaygroundSupport
import PrimeModal
import Counter

PlaygroundPage.current.liveView = UIHostingController(
    rootView: IsPrimeModalView(
        store: Store<PrimeModalViewState, PrimeModalAction>(
            initialValue: PrimeModalViewState(
                count: 5,
                favoritePrimes: [5]
            ),
            reducer: primeModalReducer
        )
    )
)
