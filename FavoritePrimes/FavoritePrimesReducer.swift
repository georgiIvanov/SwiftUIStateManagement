//
//  FavoritePrimesReducer.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture

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
        return [saveEffect(favoritePrimes: state)]
    case .loadButtonTapped:
        return [loadEffect().compactMap { $0 }.eraseToEffect()]
    }
}

private func loadEffect() -> Effect<FavoritePrimesAction?> {
    return .sync {
        guard let data = try? Data(contentsOf: getFavoritePrimesUrl()),
              let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data) else {
            return nil
        }
        
        return .loadedFavoritePrimes(favoritePrimes)
    }
}

private func saveEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimesAction> {
    return .fireAndForget {
        let data = try! JSONEncoder().encode(favoritePrimes)
        try! data.write(to: getFavoritePrimesUrl())
    }
}

private func getFavoritePrimesUrl() -> URL {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)[0]
    
    let documentsUrl = URL(fileURLWithPath: documentPath)
    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favoritePrimes.json")
    return favoritePrimesUrl
}
