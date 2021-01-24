//
//  Store.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 24.01.21.
//

import Foundation

class Store<Value>: ObservableObject {
    @Published var value: Value
    
    init(initialValue: Value) {
        self.value = initialValue
    }
}
