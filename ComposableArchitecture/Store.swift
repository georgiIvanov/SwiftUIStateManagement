//
//  Store.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Combine

public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]
private typealias StoreReducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public class Store<Value, Action> {
    private let reducer: StoreReducer<Value, Action>
    @Published fileprivate var value: Value
    private var storeUpdates: Cancellable?
    private var effectCancellables: Set<AnyCancellable> = []
    
    public init<Environment>(initialValue: Value,
                reducer: @escaping Reducer<Value, Action, Environment>,
                environment: Environment) {
        self.reducer = { value, action in
            reducer(&value, action, environment)
        }
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            
            var effectCancellable: AnyCancellable?
            var didComplete = false
            
            effectCancellable = effect.sink(receiveCompletion: { [weak self, weak effectCancellable] _ in
                didComplete = true
                guard let effectCancellable = effectCancellable else {
                    return
                }
                
                self?.effectCancellables.remove(effectCancellable)
            }, receiveValue: { [weak self] in self?.send($0) }
            )
            
            if !didComplete, let effectCancellable = effectCancellable {
                self.effectCancellables.insert(effectCancellable)
            }
        }
    }
    
    /// Convert a store that understands global values and actions into a store that understands local values and actions
    public func scope<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(value),
            reducer: { (localValue, localAction, _) in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
                return []
            },
            environment: ()
        )
        
        localStore.storeUpdates = $value
            .map(toLocalValue)
            .sink { [weak localStore] (newValue) in
                localStore?.value = newValue
            }
        
        return localStore
    }
}

public extension Store where Value: Equatable {
    var view: ViewStore<Value> {
        self.view(removeDuplicates: ==)
    }
}

public extension Store {
    func view(removeDuplicates predicate: @escaping (Value, Value) -> Bool) -> ViewStore<Value> {
        let viewStore = ViewStore(initialValue: self.value)
        
        viewStore.storeUpdate = $value
            .removeDuplicates(by: predicate)
            .sink { [weak viewStore] (value) in
                viewStore?.value = value
                self
            }
        
        return viewStore
    }
}
