//
//  CounterTests.swift
//  CounterTests
//
//  Created by Voro on 2.02.21.
//

import XCTest
@testable import Counter

class CounterTests: XCTestCase {
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
        
        effects = counterViewReducer(&state, .counter(.nthPrimeResponse(3)))
        
        XCTAssertEqual(state,
                       CounterViewState(count: 2,
                                        favoritePrimes: [3, 5],
                                        alertNthPrime: PrimeAlert(prime: 3),
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
        
        effects = counterViewReducer(&state, .counter(.nthPrimeResponse(nil)))
        
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
