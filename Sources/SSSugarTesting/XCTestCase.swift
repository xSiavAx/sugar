import Foundation
import XCTest

public extension XCTestCase {
    func wait(count: Int = 1, timeout: TimeInterval = 1.0, on block: (XCTestExpectation)->Void) {
        let expectation = XCTestExpectation()
        
        expectation.expectedFulfillmentCount = count
        block(expectation)
        wait(for: [expectation], timeout: timeout)
    }
    
    func wait(time: Double) {
        let waitExpectation = XCTestExpectation(description:"Waiting")
        
        DispatchQueue.main.asyncAfter(intervalSec: time) { waitExpectation.fulfill() }
        wait(for: [waitExpectation], timeout: time + 0.1)
    }
    
    func assertError(job: () throws -> Void, checkError: (Error)->Bool) {
        do {
            try job()
            XCTAssert(false, "Error expected")
        } catch {
            XCTAssert(checkError(error), "Unexpected error \(error)")
        }
    }
}

public func XCTAssertThrows(_ expr: () throws -> Void, checkError: (Error)->Bool) {
    do {
        try expr()
        XCTFail()
    } catch {
        assert(checkError(error))
    }
}


