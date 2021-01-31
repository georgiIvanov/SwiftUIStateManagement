//
//  Store.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

public class Store<Value, Action>: ObservableObject {
    private let reducer: (inout Value, Action) -> Void
    @Published public private(set) var value: Value
    
    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        reducer(&value, action)
    }
}
