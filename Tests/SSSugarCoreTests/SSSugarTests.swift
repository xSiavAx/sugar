import Foundation
import XCTest

extension XCTestCase {
    func wait(count: Int = 1, timeout: TimeInterval = 1.0, on block: (XCTestExpectation)->Void) {
        let expectation = XCTestExpectation()
        
        expectation.expectedFulfillmentCount = count
        block(expectation)
        wait(for: [expectation], timeout: timeout)
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

class TestQueue {
    let queue: DispatchQueue
    let checker: Checker
    private static let defaultQueueValue = "testing_queue_val"
    
    init(label: String = "testing_queue", value: String = defaultQueueValue) {
        queue = DispatchQueue(label: label)
        checker = Checker(queue: queue, value: value)
    }

    func isCurrent() -> Bool {
        return checker.isCurrent()
    }
    
    func finilize() {
        checker.finilize()
    }
}

extension TestQueue {
    class Checker {
        private let queue: DispatchQueue
        let value: String
        let key: DispatchSpecificKey<String>? = DispatchSpecificKey()
        
        init(queue mQueue: DispatchQueue, value mValue: String = defaultQueueValue) {
            queue = mQueue
            value = mValue
            queue.setSpecific(key: key!, value: value)
        }
        
        deinit {
            if let _ = key {
                finilize()
            }
        }
        
        func isCurrent() -> Bool {
            return DispatchQueue.getSpecific(key: key!) == value
        }
        
        func finilize() {
            queue.setSpecific(key: key!, value: nil)
        }
    }
}
