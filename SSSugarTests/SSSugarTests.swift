import Foundation
import XCTest

extension XCTestCase {
    func wait(on block: (XCTestExpectation)->Void) {
        let expectation = XCTestExpectation()
        
        block(expectation)
        wait(for: [expectation], timeout: 1.0)
    }
}
