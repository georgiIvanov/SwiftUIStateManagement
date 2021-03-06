//
//  ComposeFunctions.swift
//  ComposableArchitecture
//
//  Created by Voro on 1.02.21.
//

import Foundation
import Combine
import CasePaths

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
    action: CasePath<GlobalAction, LocalAction>,
    environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    return { globalValue, globalAction, globalEnvironment in
        guard let localAction = action.extract(from: globalAction) else {
            return []
        }
        
        let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
        return localEffects.map { localEffect in
            localEffect.map(action.embed)
            .eraseToEffect()
        }
    }
}

public func logging<Value, Action, Environment>(
    _ reducer: @escaping Reducer<Value, Action, Environment>,
    logger: @escaping (Environment) -> (String) -> Void
) -> Reducer<Value, Action, Environment> {
    return { value, action, environment in
        let effects = reducer(&value, action, environment)
        let valueCopy = value
        
        return [.fireAndForget {
            let logFunc = logger(environment)
            logFunc("Action: \(action)")
            logFunc("Value:")
            var dumpedValue = ""
            dump(valueCopy, to: &dumpedValue)
            logFunc(dumpedValue)
            logFunc("---\n")
        }] + effects
    }
}
