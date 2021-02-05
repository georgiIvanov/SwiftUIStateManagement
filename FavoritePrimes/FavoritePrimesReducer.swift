//
//  FavoritePrimesReducer.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation
import ComposableArchitecture

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> Effect {
    switch action {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
        return {}
    case let .loadedFavoritePrimes(favoritePrimes):
        state = favoritePrimes
        return {}
    case .saveButtonTapped:
        let state = state
        return {
            let data = try! JSONEncoder().encode(state)
            try! data.write(to: getFavoritePrimesUrl())
        }
    }
    
    
}

func getFavoritePrimesUrl() -> URL {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)[0]
    
    let documentsUrl = URL(fileURLWithPath: documentPath)
    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favoritePrimes.json")
    return favoritePrimesUrl
}
