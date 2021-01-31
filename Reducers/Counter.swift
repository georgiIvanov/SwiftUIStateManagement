//
//  Counter.swift
//  Reducers
//
//  Created by Voro on 1.02.21.
//

import Foundation

public enum CounterAction {
    case decrTapped
    case incrTapped
}

public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .decrTapped:
        state -= 1
    case .incrTapped:
        state += 1
    }
}
