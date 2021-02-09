//
//  Store.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Combine

public struct Effect<A> {
    public let run: (@escaping (A) -> Void) -> Void
    
    public init(run: @escaping (@escaping (A) -> Void) -> Void) {
        self.run = run
    }
    
    public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
        return Effect<B> { callback in self.run { arg in callback(f(arg))} }
    }
}

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public class Store<Value, Action>: ObservableObject {
    private let reducer: Reducer<Value, Action>
    @Published public private(set) var value: Value
    private var storeUpdates: Cancellable?
    
    public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            effect.run(self.send)
        }
    }
    
    public func view<LocalValue, LocalAction>(value toLocalValue: @escaping (Value) -> LocalValue,
                                               action toGlobalAction: @escaping (LocalAction) -> Action
                                               ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(value)) { (localValue, localAction) in
            self.send(toGlobalAction(localAction))
            localValue = toLocalValue(self.value)
            return []
        }
        
        localStore.storeUpdates = $value.sink { [weak localStore] (newValue) in
            localStore?.value = toLocalValue(newValue)
        }
        
        return localStore
    }
}
