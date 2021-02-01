//
//  FavoritePrimesView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import SwiftUI
import ComposableArchitecture
import Reducers

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<[Int], FavoritePrimesAction>
    
    
    var body: some View {
        List {
            ForEach(store.value, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                store.send(.deleteFavoritePrimes(indexSet))
            })
        }
            .navigationBarTitle("Favorite Primes")
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(store: Store(initialValue: AppState(),
                                        reducer: createAppReducer()).view (value: { $0.favoritePrimes },
                                                                           action: { .favoritePrimes($0) }))
    }
}
