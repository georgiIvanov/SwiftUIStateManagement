//
//  CounterEnvironment.swift
//  Counter
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

struct CounterEnvironment {
    var nthPrime: (Int) -> Effect<Int?>
}

extension CounterEnvironment {
    static let live = CounterEnvironment { (nthPrimeNumber) -> Effect<Int?> in
        let service = WebRequestsService()
        return service.nthPrime(nthPrimeNumber)
    }
    
#if DEBUG
    static let mock = CounterEnvironment { (nthPrimeNumber) -> Effect<Int?> in
        .sync { 17 }
    }
#endif
}

#if DEBUG
var currentEnv = CounterEnvironment.live
#else
let currentEnv = CounterEnvironment.live
#endif
