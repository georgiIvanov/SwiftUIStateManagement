import ComposableArchitecture
import FavoritePrimes
import SwiftUI
import PlaygroundSupport
import PrimeModal
import Counter

PlaygroundPage.current.liveView = UIHostingController(
    rootView: NavigationView {
            FavoritePrimesView(
                store: Store<[Int], FavoritePrimesAction>(
                    initialValue: [2, 3, 11],
                    reducer: favoritePrimesReducer
                ))
        }
)

