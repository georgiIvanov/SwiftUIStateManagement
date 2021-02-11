//
//  CounterTests.swift
//  CounterTests
//
//  Created by Voro on 2.02.21.
//

import XCTest
@testable import Counter
import Combine

class CounterTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        currentEnv = .mock
    }
    
    func testIncrButtonTapped() throws {
        var state = CounterViewState(count: 2,
                                     favoritePrimes: [3, 5],
                                     alertNthPrime: nil,
                                     isNthPrimeButtonDisabled: false)
        
        let effects = counterViewReducer(&state, .counter(.incrTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 3,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
    }
    
    func testDecrButtonTapped() throws {
        var state = CounterViewState(count: 2,
                                     favoritePrimes: [3, 5],
                                     alertNthPrime: nil,
                                     isNthPrimeButtonDisabled: false)
        
        let effects = counterViewReducer(&state, .counter(.decrTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 1,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
    }
    
    func testNthPrimeButtonHappyFlow() throws {
        
        let nthPrime = 17
        
        currentEnv.nthPrime = { _ in .sync { nthPrime } }
        
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
            XCTAssertEqual(action, .counter(.nthPrimeResponse(nthPrime)))
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
                                        alertNthPrime: PrimeAlert(prime: nthPrime),
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
        
        effects = counterViewReducer(&state, .counter(.alertDismissButtonTapped))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: nil,
                                        isNthPrimeButtonDisabled: false))
        XCTAssert(effects.isEmpty)
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
