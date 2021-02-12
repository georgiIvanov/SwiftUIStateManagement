//
//  Step.swift
//  CounterTests
//
//  Created by Voro on 11.02.21.
//

import Foundation

public enum StepType {
    case send
    case receive
}

public struct Step<Value, Action> {
    let type: StepType
    let action: Action
    let update: (inout Value) -> Void
    let file: StaticString
    let line: UInt
    
    public init(
        _ type: StepType,
        _ action: Action,
        _ update: @escaping (inout Value) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) {
        self.type = type
        self.action = action
        self.update = update
        self.file = file
        self.line = line
    }
}
