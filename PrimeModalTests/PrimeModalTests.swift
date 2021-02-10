import XCTest
@testable import PrimeModal

class PrimeModalTests: XCTestCase {
    func testSaveFavoritePrimeTapped() throws {
        var state = PrimeModalViewState(count: 2, favoritePrimes: [3, 5])
        let effects = primeModalReducer(state: &state, action: .saveFavoritePrimeTapped)
        
        XCTAssertEqual(state.count, 2)
        XCTAssertEqual(state.favoritePrimes, [3, 5, 2])
        XCTAssert(effects.isEmpty)
    }
    
    func testRemoveFavoritePrimeTapped() throws {
        var state = PrimeModalViewState(count: 3, favoritePrimes: [3, 5])
        let effects = primeModalReducer(state: &state, action: .removeFavoritePrimeTapped)
        
        XCTAssertEqual(state.count, 3)
        XCTAssertEqual(state.favoritePrimes, [5])
        XCTAssert(effects.isEmpty)
    }
}
