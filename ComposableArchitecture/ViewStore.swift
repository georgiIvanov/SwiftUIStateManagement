//
//  ViewStore.swift
//  ComposableArchitecture
//
//  Created by Voro on 15.02.21.
//

import Foundation
import Combine

public final class ViewStore<Value>: ObservableObject {
    @Published public internal(set) var value: Value
    var storeUpdate: Cancellable?
    
    public init(initialValue value: Value) {
        self.value = value
    }
}
