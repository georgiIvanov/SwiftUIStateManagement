//
//  CounterTests.swift
//  CounterTests
//
//  Created by Voro on 2.02.21.
//

import XCTest
@testable import Counter
import Combine
import ComposableArchitecture

class CounterTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        currentEnv = .mock
    }
    
    func testIncrButtonTapped() throws {
        assert(initialValue: CounterViewState(count: 2),
               reducer: counterViewReducer,
               steps:
                Step(.send,.counter(.incrTapped)) { state in state.count = 3 },
                Step(.send,.counter(.incrTapped)) { state in state.count = 4 },
                Step(.send,.counter(.decrTapped)) { state in state.count = 3 }
        )
    }
    
    func testDecrButtonTapped() throws {
        assert(initialValue: CounterViewState(count: 3),
               reducer: counterViewReducer,
               steps:
                Step(.send, .counter(.decrTapped)) { state in state.count = 2 },
                Step(.send, .counter(.decrTapped)) { state in state.count = 1 },
                Step(.send, .counter(.decrTapped)) { state in state.count = 0 })
    }
    
    func testNthPrimeButtonHappyFlow() throws {
        let nthPrime = 17
        currentEnv.nthPrime = { _ in .sync { nthPrime } }
        
        assert(initialValue: CounterViewState(alertNthPrime: nil,
                                              isNthPrimeButtonDisabled: false),
               reducer: counterViewReducer,
               steps:
                Step(.send, .counter(.nthPrimeButtonTapped), {
                    $0.isNthPrimeButtonDisabled = true
                }),
                Step(.receive, .counter(.nthPrimeResponse(nthPrime)), {
                    $0.isNthPrimeButtonDisabled = false
                    $0.alertNthPrime = PrimeAlert(prime: nthPrime)
                }),
                Step(.send, .counter(.alertDismissButtonTapped), {
                    $0.alertNthPrime = nil
                })
        )
        
        // Original code for testing
        
//        var state = CounterViewState(alertNthPrime: nil,
//                                     isNthPrimeButtonDisabled: false)
//        var expected = state
//        var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))
//
//        expected.isNthPrimeButtonDisabled = true
//        XCTAssertEqual(state, expected)
//        XCTAssertEqual(effects.count, 1)
//
//        var nextAction: CounterViewAction!
//        let receivedCompletion = expectation(description: "receivedCompletion")
//
//        let cancellable = effects[0].sink(receiveCompletion: { _ in
//            receivedCompletion.fulfill()
//        }, receiveValue: { action in
//            XCTAssertEqual(action, .counter(.nthPrimeResponse(nthPrime)))
//            nextAction = action
//        })
//
//        // We need to hold cancellable to receive sink events
//        // then silence the warning for not using it anywhere by using method below
//        withExtendedLifetime(cancellable, {})
//
//        wait(for: [receivedCompletion], timeout: 0.01)
//        effects = counterViewReducer(&state, nextAction)
//
//        expected.alertNthPrime = PrimeAlert(prime: nthPrime)
//        expected.isNthPrimeButtonDisabled = false
//        XCTAssertEqual(state, expected)
//        XCTAssert(effects.isEmpty)
//
//        effects = counterViewReducer(&state, .counter(.alertDismissButtonTapped))
//
//        expected.alertNthPrime = nil
//        XCTAssertEqual(state, expected)
//        XCTAssert(effects.isEmpty)
    }
    
    func testNthPrimeButtonUnhappyFlow() throws {
        
        // TODO: Make nth prime return error and test for it
        currentEnv.nthPrime = { _ in .sync { nil } }
        
        var state = CounterViewState(count: 2,
                                     favoritePrimes: [3, 5],
                                     alertNthPrime: nil,
                                     isNthPrimeButtonDisabled: false)
        
        var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: true))
        XCTAssertEqual(effects.count, 1)
        
        var nextAction: CounterViewAction!
        let receivedCompletion = expectation(description: "receivedCompletion")
        
        let cancellable = effects[0].sink(receiveCompletion: { _ in
            receivedCompletion.fulfill()
        }, receiveValue: { action in
            XCTAssertEqual(action, .counter(.nthPrimeResponse(nil)))
            nextAction = action
        })
        
        // We need to hold cancellable to receive sink events
        // then silence the warning for not using it anywhere by using method below
        withExtendedLifetime(cancellable, {})
        
        wait(for: [receivedCompletion], timeout: 0.01)
        effects = counterViewReducer(&state, nextAction)
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
    }
    
    func testPrimeModal() throws {
        var state = CounterViewState(count: 2,
                                     favoritePrimes: [3, 5],
                                     alertNthPrime: nil,
                                     isNthPrimeButtonDisabled: false)
        
        var effects = counterViewReducer(&state, .primeModal(.saveFavoritePrimeTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5, 2],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
        
        effects = counterViewReducer(&state, .primeModal(.removeFavoritePrimeTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
        
        
    }
}
