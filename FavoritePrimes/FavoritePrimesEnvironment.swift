//
//  FavoritePrimesEnvironment.swift
//  FavoritePrimes
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

// In the future when more dependencies are added we can turn this into a tuple
// = (fileClient: FileClient, x: X...)
public typealias FavoritePrimesEnvironment = FileClient

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

