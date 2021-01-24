//
//  FavoritePrimesView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var state: AppState
    
    
    var body: some View {
        List {
            ForEach(self.state.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    self.state.favoritePrimes.remove(at: index)
                    self.state.activityFeed.append(.init(timestamp: Date(),
                                                         type: .removedFavoritePrime(self.state.count)))
                }
            })
        }
            .navigationBarTitle("Favorite Primes")
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(state: AppState())
    }
}
