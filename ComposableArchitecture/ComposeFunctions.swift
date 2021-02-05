//
//  ComposeFunctions.swift
//  ComposableArchitecture
//
//  Created by Voro on 1.02.21.
//

import Foundation

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.map { $0(&value, action) }
        return {
            for effect in effects {
                effect()
            }
        }
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return {}
        }
        
        return reducer(&globalValue[keyPath: value], localAction)
    }
}

public func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    return { value, action in
        let effect = reducer(&value, action)
        let valueCopy = value
        return {
            print("Action: \(action)")
            print("Value:")
            dump(valueCopy)
            print("---\n")
            effect()
        }
    }
}
