//
//  FavoritePrimesEnvironment.swift
//  FavoritePrimes
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

public struct FavoritePrimesEnvironment {
    var fileClient: FileClient
}

public extension FavoritePrimesEnvironment {
    static let live = FavoritePrimesEnvironment(fileClient: .live)
    
#if DEBUG
    static let mock = FavoritePrimesEnvironment(fileClient: FileClient(
                                                    load: { _ in .sync {
                                                        try! JSONEncoder().encode([2, 31])
                                                    } },
                                                    save: {_, _ in
                                                        .fireAndForget { }
                                                    })
    )
#endif
    
}

