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
                    initialValue: [2, 3, 11, 7, 19, 67],
                    reducer: favoritePrimesReducer
                ))
        }
)

