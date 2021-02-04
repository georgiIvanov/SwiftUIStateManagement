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

public enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)
    case loadedFavoritePrimes([Int])

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
    @ObservedObject var store: Store<[Int], FavoritePrimesAction>
    
    public init(store: Store<[Int], FavoritePrimesAction>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(store.value, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                store.send(.deleteFavoritePrimes(indexSet))
            })
        }
        .navigationBarTitle("Favorite Primes")
        .navigationBarItems(
            trailing: HStack {
                Button("Save") {
                    let data = try! JSONEncoder().encode(store.value)
                    try! data.write(to: getFavoritePrimesUrl())
                }
                Button("Load") {
                    guard let data = try? Data(contentsOf: getFavoritePrimesUrl()),
                          let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data) else {
                        return
                    }
                    
                    store.send(.loadedFavoritePrimes(favoritePrimes ))
                }
        })
    }
}

func getFavoritePrimesUrl() -> URL {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)[0]
    
    let documentsUrl = URL(fileURLWithPath: documentPath)
    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favoritePrimes.json")
    return favoritePrimesUrl
}
