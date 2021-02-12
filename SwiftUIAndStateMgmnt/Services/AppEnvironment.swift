//
//  AppEnvironment.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 12.02.21.
//

import Foundation
import Counter
import FavoritePrimes

struct AppEnvironment {
    var counter: CounterEnvironment
    var favoritePrimes: FavoritePrimesEnvironment
    
    static let live: AppEnvironment = {
        AppEnvironment(counter: .live, favoritePrimes: .live)
    }()
    
#if DEBUG
    static var mock: AppEnvironment = {
        AppEnvironment(counter: .mock, favoritePrimes: .mock)
    }()
#endif
}
