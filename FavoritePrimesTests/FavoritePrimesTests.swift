//
//  FavoritePrimesTests.swift
//  FavoritePrimesTests
//
//  Created by Voro on 1.02.21.
//

import XCTest
@testable import FavoritePrimes

let mockEnv = {
    FavoritePrimesEnvironment.mock
}()

class FavoritePrimesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        currentEnv = mockEnv
    }
    
    func testDeleteFavoritePrimes() throws {
        var state = [2, 3, 5, 7]
        let effects = favoritePrimesReducer(state: &state, action: .deleteFavoritePrimes([2]))
        
        XCTAssertEqual(state, [2, 3, 7])
        XCTAssertTrue(effects.isEmpty)
    }
    
    func testSaveButtonTapped() throws {
        var didSave = false
        currentEnv.fileClient.save = { _, data in
            // TODO: Verify that data was encoded correctly to strenghten test
            .fireAndForget {
                didSave = true
            }
        }
        
        var state = [2, 3, 5, 7]
        let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped)
        
        XCTAssertEqual(state, [2, 3, 5, 7])
        XCTAssertEqual(effects.count, 1)
        
        // We know that the save effect will not send action back to the system
        // If this effect by chance emits something the test will fail
        let _ = effects[0].sink { action in
            XCTFail()
        }
        
        XCTAssert(didSave)
    }
    
    func testLoadFavoritePrimesFlow() throws {
        let loadPrimes = [2, 31]
        
        currentEnv.fileClient.load = { _ in
            .sync {
                return try! JSONEncoder().encode(loadPrimes)
            }
        }
        
        var state = [2, 3, 5, 7]
        var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped)
        
        XCTAssertEqual(state, [2, 3, 5, 7])
        XCTAssertEqual(effects.count, 1)
        
        var nextAction: FavoritePrimesAction!
        let receivedCompletion = expectation(description: "receivedCompletion")
        
        // TODO: Assert this action is received only once
        // To simulate such case add this line in reducer before calling eraseToEffect()
        // .merge(with: Just(FavoritePrimesAction.loadedFavoritePrimes([2, 31])))
        let _ = effects[0].sink(receiveCompletion: { _ in
            receivedCompletion.fulfill()
        }, receiveValue: { action in
            XCTAssertEqual(action, .loadedFavoritePrimes(loadPrimes))
            nextAction = action
        })
        
        effects = favoritePrimesReducer(state: &state, action: nextAction)
        
        XCTAssertEqual(state, loadPrimes)
        XCTAssert(effects.isEmpty)
        // This proves there are no future actions emitted
        wait(for: [receivedCompletion], timeout: 0)
    }

}
