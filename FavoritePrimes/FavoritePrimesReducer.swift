//
//  FavoritePrimesReducer.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture
import Combine

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
    switch action {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
        return []
    case let .loadedFavoritePrimes(favoritePrimes):
        state = favoritePrimes
        return []
    case .saveButtonTapped:
        return [currentEnv.fileClient.save("favoritePrimes.json",
                                        try! JSONEncoder().encode(state)).fireAndForget()]
    case .loadButtonTapped:
        // TODO: Handle error
        return [currentEnv.fileClient
                    .load("favoritePrimes.json")
                    .compactMap { $0 }
                    .decode(type: [Int].self, decoder: JSONDecoder())
                    .catch { error in Empty(completeImmediately: true) }
                    .map(FavoritePrimesAction.loadedFavoritePrimes)
                    .eraseToEffect()
        ]
    }
}
