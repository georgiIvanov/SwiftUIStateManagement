//
//  SwiftUIAndStateMgmntTests.swift
//  SwiftUIAndStateMgmntTests
//
//  Created by Voro on 23.01.21.
//

import XCTest
@testable import SwiftUIAndStateMgmnt
import ComposableArchitecture
@testable import FavoritePrimes
@testable import PrimeModal
@testable import Counter
@testable import ComposableArchitectureTestSupport

class SwiftUIAndStateMgmntTests: XCTestCase {
    
    var environment: AppEnvironment!
    
    override func setUp() {
        super.setUp()
        environment = mockEnvironment
    }

    func testIntegration() {
        environment.nthPrime = { _ in .sync { 17 }}
        environment.fileClient = FileClient.mock
        environment.fileClient.load = { (fileName) in
            .sync { try! JSONEncoder().encode([2, 31, 7]) }
        }
        
        assert(initialValue: AppState(),
               reducer: createAppReducer(),
               environment: environment,
               steps:
                Step(.send, .counterView(.counter(.nthPrimeButtonTapped)), {
                    $0.isNthPrimeButtonDisabled = true
                }),
               Step(.receive, .counterView(.counter(.nthPrimeResponse(17))), {
                $0.isNthPrimeButtonDisabled = false
                $0.alertNthPrime = PrimeAlert(prime: 17)
               }),
               Step(.send, .favoritePrimes(.loadButtonTapped)),
               Step(.receive, .favoritePrimes(.loadedFavoritePrimes([2, 31, 7]))) {
                $0.favoritePrimes = [2, 31, 7]
               }
        )
    }
    
}
