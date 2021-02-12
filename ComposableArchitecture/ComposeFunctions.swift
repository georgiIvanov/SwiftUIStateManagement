//
//  ComposeFunctions.swift
//  ComposableArchitecture
//
//  Created by Voro on 1.02.21.
//

import Foundation
import Combine

public func combine<Value, Action, Environment>(
    _ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
    return { value, action, environment in
        let effects = reducers.flatMap { $0(&value, action, environment) }
        return effects
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>,
    environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    return { globalValue, globalAction, globalEnvironment in
        guard let localAction = globalAction[keyPath: action] else {
            return []
        }
        
        let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
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

public func logging<Value, Action, Environment>(
    _ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
    return { value, action, environment in
        let effects = reducer(&value, action, environment)
        let valueCopy = value
        
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value:")
            dump(valueCopy)
            print("---\n")
        }] + effects
    }
}
