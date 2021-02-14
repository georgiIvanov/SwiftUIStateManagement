//
//  FavoritePrimesReducer.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture
import Combine
import PrimeAlert

public typealias FavoritePrimesState = (
    alertNthPrime: PrimeAlert?,
    favoritePrimes: [Int]
)

public func favoritePrimesReducer(state: inout FavoritePrimesState,
                                  action: FavoritePrimesAction,
                                  environment: FavoritePrimesEnvironment) -> [Effect<FavoritePrimesAction>] {
    switch action {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            state.favoritePrimes.remove(at: index)
        }
        return []
    case let .loadedFavoritePrimes(favoritePrimes):
        state.favoritePrimes = favoritePrimes
        return []
    case .saveButtonTapped:
        return [environment.fileClient.save("favoritePrimes.json",
                                            try! JSONEncoder().encode(state.favoritePrimes)).fireAndForget()]
    case .loadButtonTapped:
        // TODO: Handle error
        return [environment.fileClient
                    .load("favoritePrimes.json")
                    .compactMap { $0 }
                    .decode(type: [Int].self, decoder: JSONDecoder())
                    .catch { error in Empty(completeImmediately: true) }
                    .map(FavoritePrimesAction.loadedFavoritePrimes)
                    .eraseToEffect()
        ]
    case let .primeButtonWasTapped(n):
        return [
            environment.nthPrime(n)
                .map { FavoritePrimesAction.nthPrimeResponse(n: n, prime: $0) }
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        ]
    case let .nthPrimeResponse(n, prime):
        state.alertNthPrime = prime.map { PrimeAlert.init(n: n, prime: $0) }
        return []
    case .alertDismissButtonTapped:
        state.alertNthPrime = nil
        return []
    }
}
