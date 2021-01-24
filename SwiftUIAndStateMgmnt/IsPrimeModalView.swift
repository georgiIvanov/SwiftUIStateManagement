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
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if isPrime(self.state.count) {
                Text("\(self.state.count) is prime 🎉")
                if self.state.favoritePrimes.contains(self.state.count) {
                    Button(action: {
                        self.state.favoritePrimes
                            .removeAll { $0 == self.state.count }
                        self.state.activityFeed.append(.init(timestamp: Date(),
                                                             type: .removedFavoritePrime(self.state.count)))
                    }, label: {
                        Text("Remove from favorite primes.")
                    })
                } else {
                    Button(action: {
                        self.state.favoritePrimes.append(self.state.count)
                        self.state.activityFeed.append(.init(timestamp: Date(),
                                                             type: .addedFavoritePrime(self.state.count)))
                    }, label: {
                        Text("Save to favorite primes.")
                    })
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
        }
        
    }
}

struct IsPrimeModalView_Previews: PreviewProvider {
    static var previews: some View {
        IsPrimeModalView(state: AppState())
    }
}
