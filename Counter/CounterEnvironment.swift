//
//  CounterEnvironment.swift
//  Counter
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

public struct CounterEnvironment {
    var nthPrime: (Int) -> Effect<Int?>
    var log: (String) -> Void
}

public extension CounterEnvironment {
    static let live = CounterEnvironment { (nthPrimeNumber) -> Effect<Int?> in
        return WebRequestsService().nthPrime(nthPrimeNumber)
    } log: { (valueToLog) in
        print(valueToLog)
    }
    
#if DEBUG
    static let mock = CounterEnvironment { (nthPrimeNumber) -> Effect<Int?> in
        .sync { 17 }
    } log: { (valueToLog) in
        print(valueToLog)
    }
#endif
}
