//
//  AppState.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import Foundation
import Combine
import PrimeModal
import Counter

struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var alertNthPrime: PrimeAlert?
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
    
    struct Activity {
        let timestamp: Date
        let type: ActivityType
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
    
    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

extension AppState {
    var favoritePrimesState: FavoritePrimesState {
        get {
            return FavoritePrimesState(favoritePrimes: favoritePrimes,
                                       activityFeed: activityFeed)
        }
        
        set {
            favoritePrimes = newValue.favoritePrimes
            activityFeed = newValue.activityFeed
        }
    }
    
    var counterView: CounterViewState {
        get {
            return CounterViewState(count: self.count,
                                    favoritePrimes: self.favoritePrimes,
                                    alertNthPrime: alertNthPrime,
                                    isNthPrimeButtonDisabled: false)
        }
        
        set {
            self.count = newValue.counter.count
            self.favoritePrimes = newValue.favoritePrimes
            self.alertNthPrime = newValue.alertNthPrime
        }
    }
}
