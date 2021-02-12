//
//  CounterEnvironment.swift
//  Counter
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

public typealias CounterEnvironment = (
    nthPrime: (Int) -> Effect<Int?>,
    log: (String) -> Void
)

#if DEBUG
var mockNthPrime: (Int) -> Effect<Int?> = { _ in
    .sync { 17 }
}

var mockLog: (String) -> Void = {(valueToLog) in
    print(valueToLog)
}
#endif
