//
//  FavoritePrimesView.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import Foundation
import SwiftUI
import Combine
import ComposableArchitecture

public enum FavoritePrimesAction: Equatable {
    case deleteFavoritePrimes(IndexSet)
    case loadedFavoritePrimes([Int])
    case saveButtonTapped
    case loadButtonTapped
    case primeButtonWasTapped(Int)
    case nthPrimeResponse(n: Int, prime:Int?)
    case alertDismissButtonTapped
    
    var deleteFavoritePrimes: IndexSet? {
        get {
            guard case let .deleteFavoritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .deleteFavoritePrimes = self, let newValue = newValue else { return }
            self = .deleteFavoritePrimes(newValue)
        }
    }
}

public struct FavoritePrimesView: View {
    let store: Store<FavoritePrimesState, FavoritePrimesAction>
    @ObservedObject var viewStore: ViewStore<FavoritePrimesState>
    
    public init(store: Store<FavoritePrimesState, FavoritePrimesAction>) {
        self.store = store
        self.viewStore = store.view(removeDuplicates: ==)
    }
    
    public var body: some View {
        List {
            ForEach(viewStore.value.favoritePrimes, id: \.self) { prime in
                Button("\(prime)") {
                    self.store.send(.primeButtonWasTapped(prime))
                }
            }
            .onDelete(perform: { indexSet in
                store.send(.deleteFavoritePrimes(indexSet))
            })
        }
        .navigationBarTitle("Favorite Primes")
        .navigationBarItems(
            trailing: HStack {
                Button("Save") {
                    store.send(.saveButtonTapped)
                }
                Button("Load") {
                    store.send(.loadButtonTapped)
                }
            })
        .alert(item: .constant(viewStore.value.alertNthPrime), content: { (prime) -> Alert in
            Alert(title: Text(prime.title),
                  dismissButton: .default(Text("Ok"), action: {
                    self.store.send(.alertDismissButtonTapped)
                  }))
        })
    }
}
