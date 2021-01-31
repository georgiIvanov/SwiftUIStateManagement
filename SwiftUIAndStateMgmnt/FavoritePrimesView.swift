//
//  FavoritePrimesView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    
    var body: some View {
        List {
            ForEach(store.value.favoritePrimes, id: \.self) { prime in
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
        FavoritePrimesView(store: Store(initialValue: AppState(), reducer: createAppReducer()))
    }
}
