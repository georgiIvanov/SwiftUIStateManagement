import ComposableArchitecture
@testable import FavoritePrimes
import SwiftUI
import PlaygroundSupport
import PrimeModal
import Counter

var environment: FavoritePrimesEnvironment = (
    fileClient: FileClient.mock,
    nthPrime: { _ in .sync { 17 } }
)
environment.fileClient.load = { _ in
    Effect.sync { try! JSONEncoder().encode(Array(1...10)) }
}

PlaygroundPage.current.liveView = UIHostingController(
    rootView: NavigationView {
            FavoritePrimesView(
                store: Store<FavoritePrimesState, FavoritePrimesAction>(
                    initialValue: (alertNthPrime: nil, favoritePrimes: [2, 3, 11, 7, 19, 67]),
                    reducer: favoritePrimesReducer,
                    environment: environment
                ))
        }
)

