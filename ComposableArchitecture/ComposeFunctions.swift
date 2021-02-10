//
//  ComposeFunctions.swift
//  ComposableArchitecture
//
//  Created by Voro on 1.02.21.
//

import Foundation
import Combine

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return []
        }
        
        let localEffects = reducer(&globalValue[keyPath: value], localAction)
        return localEffects.map { localEffect in
            localEffect.map { localAction in
                var globalAction = globalAction
                    globalAction[keyPath: action] = localAction
                    return globalAction
            }
            .eraseToEffect()
        }
    }
}

public func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducer(&value, action)
        let valueCopy = value
        
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value:")
            dump(valueCopy)
            print("---\n")
        }] + effects
    }
}
