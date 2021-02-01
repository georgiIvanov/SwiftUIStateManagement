//
//  IsPrimeModalView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture

private func isPrime (_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

public struct PrimeModalViewState {
    public var count: Int
    public var favoritePrimes:  [Int]
    
    public init(count: Int, favoritePrimes:  [Int]) {
        self.count = count
        self.favoritePrimes = favoritePrimes
    }
}

public struct IsPrimeModalView: View {
    @ObservedObject var store: Store<PrimeModalViewState, PrimeModalAction>
    
    public init(store: Store<PrimeModalViewState, PrimeModalAction>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime 🎉")
                if store.value.favoritePrimes.contains(store.value.count) {
                    Button(action: {
                        store.send(.removeFavoritePrimeTapped)
                    }, label: {
                        Text("Remove from favorite primes.")
                    })
                } else {
                    Button(action: {
                        store.send(.saveFavoritePrimeTapped)
                    }, label: {
                        Text("Save to favorite primes.")
                    })
                }
            } else {
                Text("\(store.value.count) is not prime :(")
            }
        }
        
    }
}

struct IsPrimeModalView_Previews: PreviewProvider {
    static var previews: some View {
        IsPrimeModalView(store: Store(
                            initialValue: PrimeModalViewState(count: 0, favoritePrimes: []),
                            reducer: primeModalReducer))
    }
}
