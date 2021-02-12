//
//  TestSupport.swift
//  CounterTests
//
//  Created by Voro on 11.02.21.
//

import Foundation
import XCTest
import ComposableArchitecture

func assert<Value: Equatable, Action: Equatable, Environment>(initialValue: Value,
            reducer: Reducer<Value, Action, Environment>,
            environment: Environment,
            steps: Step<Value, Action>...,
            file: StaticString = #file,
            line: UInt = #line) {
    
    var state = initialValue
    var effects = [Effect<Action>]()
    
    steps.forEach { step in
        var expected = state
        switch step.type {
        case .send:
            if !effects.isEmpty {
                XCTFail("Action sent before handling \(effects.count) pending effect/s!", file: step.file, line: step.line)
            }
            effects.append(contentsOf: reducer(&state, step.action, environment))
        case .receive:
            guard !effects.isEmpty else {
                XCTFail("No pending effects to receive from.", file: step.file, line: step.line)
                break
            }
            
            let effect = effects.removeFirst()
            var action: Action!
            let receivedCompletion = XCTestExpectation(description: "receivedCompletion")
            let cancellable = effect.sink(
                receiveCompletion: { _ in
                    receivedCompletion.fulfill()
                },
                receiveValue: { action = $0 }
            )
            
            // We need to hold cancellable to receive sink events
            // then silence the warning for not using it anywhere by using method below
            withExtendedLifetime(cancellable, {})
            
            if XCTWaiter.wait(for: [receivedCompletion], timeout: 0.01) != .completed {
                XCTFail("Timed out while waiting for effect to complete.", file: step.file, line: step.line)
            }
            
            XCTAssertEqual(action, step.action, file: step.file, line: step.line)
            effects.append(contentsOf: reducer(&state, step.action, environment))
        }
        
        step.update(&expected)
        XCTAssertEqual(state, expected, file: step.file, line: step.line)
    }
    
    if !effects.isEmpty {
        XCTFail("Action sent before handling \(effects.count) pending effect/s!", file: file, line: line)
    }
}
