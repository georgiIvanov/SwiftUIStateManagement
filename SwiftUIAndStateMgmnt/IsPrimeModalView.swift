//
//  IsPrimeModalView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI

private func isPrime (_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
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
        IsPrimeModalView(store: Store(initialValue: AppState(), reducer: counterReducer(state:action:)))
    }
}
