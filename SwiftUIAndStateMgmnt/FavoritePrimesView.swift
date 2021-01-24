//
//  FavoritePrimesView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState>
    
    
    var body: some View {
        List {
            ForEach(store.value.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    store.value.favoritePrimes.remove(at: index)
                    store.value.activityFeed.append(.init(timestamp: Date(),
                                                         type: .removedFavoritePrime(store.value.count)))
                }
            })
        }
            .navigationBarTitle("Favorite Primes")
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(store: Store<AppState>(initialValue: AppState()))
    }
}
