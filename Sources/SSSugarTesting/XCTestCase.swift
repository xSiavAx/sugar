import Foundation
import XCTest

public extension XCTestCase {
    func wait<T>(count: Int = 1, description: String? = nil, timeout: TimeInterval = 1.0, on block: (XCTestExpectation) -> T) -> T {
        let expectation = Self.expectationWith(descr: description)
        
        expectation.expectedFulfillmentCount = count
        let result = block(expectation)
        
        wait(for: [expectation], timeout: timeout)
        return result
    }
    
    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `wait(count: description: timeout: on block:` instead")
    func wait<T>(fullFillCount: Int, description: String? = nil, timeout: Double = 1.0, on block: (XCTestExpectation) -> T) -> T {
        wait(count: fullFillCount, description: description, timeout: timeout, on: block)
    }
    
    func wait(time: Double) {
        wait(description: "Waiting for \(time) secconds", timeout: time) {
            $0.fulfill()
        }
    }
    
    func nonThrow<T>(_ job: () throws -> T) -> T {
        do {
            return try job()
        } catch {
            XCTFail("Unexpected error has thrown \(error)/")
            fatalError()
        }
    }

    func assertError(job: () throws -> Void, checkError: (Error)->Bool) {
        do {
            try job()
            XCTAssert(false, "Error expected")
        } catch {
            XCTAssert(checkError(error), "Unexpected error \(error)")
        }
    }
    
    private static func expectationWith(descr: String?) -> XCTestExpectation {
        if let desc = descr {
            return XCTestExpectation(description: desc)
        }
        return XCTestExpectation()
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


