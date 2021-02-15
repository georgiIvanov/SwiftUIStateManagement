//
//  ContentView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture
import FavoritePrimes
import Counter

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(
                    store: store.scope(value: { $0.counterView },
                                      action: { .counterView($0) })
                )) {
                    Text("Counter demo")
                }
                NavigationLink(destination: CounterView(
                    store: store.scope(value: { $0.counterView },
                                      action: { .offlineCounterView($0) })
                )) {
                    Text("Offline counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(store: store.scope(value: { $0.favoritePrimesState },
                                                                                 action: { .favoritePrimes($0) }))
                ) {
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
                                                      reducer: createAppReducer(),
                                                      environment: mockEnvironment))
    }
}
