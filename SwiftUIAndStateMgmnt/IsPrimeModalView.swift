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

struct IsPrimeModalViewState {
    var count: Int
    var favoritePrimes:  [Int]
}

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<IsPrimeModalViewState, AppAction>
    
    var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime 🎉")
                if store.value.favoritePrimes.contains(store.value.count) {
                    Button(action: {
                        store.send(.primeModal(.removeFavoritePrimeTapped))
                    }, label: {
                        Text("Remove from favorite primes.")
                    })
                } else {
                    Button(action: {
                        store.send(.primeModal(.saveFavoritePrimeTapped))
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
        IsPrimeModalView(store: Store(initialValue: AppState(), reducer: createAppReducer()).view {
            IsPrimeModalViewState(count: $0.count, favoritePrimes: $0.favoritePrimes)
        })
    }
}
