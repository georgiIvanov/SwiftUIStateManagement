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

public struct PrimeModalViewState: Equatable {
    public var count: Int
    public var favoritePrimes:  [Int]
    
    public init(count: Int, favoritePrimes:  [Int]) {
        self.count = count
        self.favoritePrimes = favoritePrimes
    }
}

public struct IsPrimeModalView: View {
    let store: Store<PrimeModalViewState, PrimeModalAction>
    @ObservedObject var viewStore: ViewStore<PrimeModalViewState>
    
    public init(store: Store<PrimeModalViewState, PrimeModalAction>) {
        self.store = store
        self.viewStore = store.view
    }
    
    public var body: some View {
        VStack {
            if isPrime(viewStore.value.count) {
                Text("\(viewStore.value.count) is prime 🎉")
                if viewStore.value.favoritePrimes.contains(viewStore.value.count) {
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
                Text("\(viewStore.value.count) is not prime :(")
            }
        }
        
    }
}

struct IsPrimeModalView_Previews: PreviewProvider {
    static var previews: some View {
        IsPrimeModalView(store: Store(
                            initialValue: PrimeModalViewState(count: 0, favoritePrimes: []),
                            reducer: primeModalReducer,
                            environment: ()))
    }
}
