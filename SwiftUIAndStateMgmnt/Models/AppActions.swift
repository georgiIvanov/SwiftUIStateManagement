//
//  CounterAction.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Foundation

enum CounterAction {
    case decrTapped
    case incrTapped
}

enum PrimeModalAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)
}

// All the actions user can perform in the App
enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favoritePrimes(FavoritePrimesAction)
}
