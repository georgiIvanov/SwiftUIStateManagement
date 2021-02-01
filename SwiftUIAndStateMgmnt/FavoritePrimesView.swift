//
//  FavoritePrimesView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<[Int], AppAction>
    
    
    var body: some View {
        List {
            ForEach(store.value, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
            })
        }
            .navigationBarTitle("Favorite Primes")
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(store: Store(initialValue: AppState(), reducer: createAppReducer()).view { $0.favoritePrimes })
    }
}
