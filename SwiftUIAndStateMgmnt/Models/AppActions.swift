//
//  CounterAction.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Foundation
import FavoritePrimes
import Counter

// All the actions user can perform in the App
enum AppAction: Equatable {
    case counterView(CounterFeatureAction)
    case offlineCounterView(CounterFeatureAction)
    case favoritePrimes(FavoritePrimesAction)
}
