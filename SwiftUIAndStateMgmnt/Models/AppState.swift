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
import PrimeAlert
import FavoritePrimes

struct AppState: Equatable {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
    var alertNthPrime: PrimeAlert?
    var isNthPrimeButtonDisabled: Bool = false
    
    struct Activity: Equatable {
        let timestamp: Date
        let type: ActivityType
        
        enum ActivityType: Equatable {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
    
    struct User: Equatable {
        let id: Int
        let name: String
        let bio: String
    }
}

extension AppState {
    var favoritePrimesState: FavoritePrimesState {
        get {
            return (alertNthPrime, favoritePrimes)
        }
        
        set {
            (alertNthPrime, favoritePrimes) = newValue
        }
    }
    
    var counterView: CounterViewState {
        get {
            return CounterViewState(count: self.count,
                                    favoritePrimes: self.favoritePrimes,
                                    alertNthPrime: self.alertNthPrime,
                                    isNthPrimeButtonDisabled: self.isNthPrimeButtonDisabled)
        }
        
        set {
            self.count = newValue.counter.count
            self.favoritePrimes = newValue.favoritePrimes
            self.alertNthPrime = newValue.alertNthPrime
            self.isNthPrimeButtonDisabled = newValue.isNthPrimeButtonDisabled
        }
    }
}
