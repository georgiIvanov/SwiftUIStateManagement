//
//  ContentView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(
                    store: store.view { CounterViewState(count: $0.count, favoritePrimes: $0.favoritePrimes) }
                )) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(store: store.view { $0.favoritePrimes })) {
                    Text("Favorite primes")
                }
            }
            .navigationBarTitle("State management")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store<AppState, AppAction>(initialValue: AppState(),
                                                      reducer: createAppReducer()))
    }
}
