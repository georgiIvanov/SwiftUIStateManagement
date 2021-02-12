import ComposableArchitecture
@testable import FavoritePrimes
import SwiftUI
import PlaygroundSupport
import PrimeModal
import Counter

var environment = FavoritePrimesEnvironment.mock
environment.fileClient.load = { _ in
    Effect.sync { try! JSONEncoder().encode(Array(1...10)) }
}

PlaygroundPage.current.liveView = UIHostingController(
    rootView: NavigationView {
            FavoritePrimesView(
                store: Store<[Int], FavoritePrimesAction>(
                    initialValue: [2, 3, 11, 7, 19, 67],
                    reducer: favoritePrimesReducer,
                    environment: environment
                ))
        }
)

