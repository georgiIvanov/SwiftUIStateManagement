//
//  FavoritePrimesEnvironment.swift
//  FavoritePrimes
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

public typealias FavoritePrimesEnvironment = (
    fileClient: FileClient,
    nthPrime: (Int) -> Effect<Int?>
)

#if DEBUG
public extension FileClient {
    static let mock = FileClient(
        load: { _ in .sync {
            try! JSONEncoder().encode([2, 31])
        } },
        save: {_, _ in
            .fireAndForget { }
        })
}
#endif

