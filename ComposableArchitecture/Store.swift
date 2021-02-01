//
//  Store.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Combine

public class Store<Value, Action>: ObservableObject {
    private let reducer: (inout Value, Action) -> Void
    @Published public private(set) var value: Value
    private var storeUpdates: Cancellable?
    
    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        reducer(&value, action)
    }
    
    public func view<LocalValue, LocalAction >(value toLocalValue: @escaping (Value) -> LocalValue,
                                               action toGlobalAction: @escaping (LocalAction) -> Action
                                               ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(value)) { (localValue, localAction) in
            self.send(toGlobalAction(localAction))
            localValue = toLocalValue(self.value)
        }
        
        localStore.storeUpdates = $value.sink { [weak localStore] (newValue) in
            localStore?.value = toLocalValue(newValue)
        }
        
        return localStore
    }
}
