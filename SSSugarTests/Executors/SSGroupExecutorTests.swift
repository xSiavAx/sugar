/*
 Tests for SSGroupExecutor class
 
 [Done] init
 [Done] add
 [Done] zero tasks
 [Done] one task
 [Done] several tasks
 [Done] zero tasks background queue
 [Done] one task background queue
 [Done] several tasks background queue
 [Done] several tasks mixed queues
 [Done] zero tasks
 [Done] one task background finish
 [Done] several tasks background finish
 [Done] zero tasks background queue background finish
 [Done] one task background queue background finish
 [Done] several tasks background queue background finish
 [Done] several tasks mixed queues background finish
 */

import XCTest
@testable import SSSugar

class SSGroupExecutorTests: XCTestCase {
    let sut = SSGroupExecutor()

    func testInit() {
        XCTAssertNotNil(SSGroupExecutor())
    }
    
    func testAdd() {
        XCTAssertEqual(sut.tasks.count, 0)
        for index in 1...100 {
            sut.add(task())
            XCTAssertEqual(sut.tasks.count, index)
        }
    }
    
    func testZeroTasks() {
        let expectation = XCTestExpectation()
        
        sut.finish { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTask() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()

        sut.add(fulfillTask(expectationTask, in: .main))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasks() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testOneTaskBackgroundQueue() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTask, in: .global()))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundQueue() {
        let queue = DispatchQueue.global()
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
     
    func testSeveralTasksMixedQueues() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: .global()))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .global()))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testZeroTasksBackgroundFinish() {
        let expectation = XCTestExpectation()
        
        sut.finish(queue: .global()) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTaskBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTask, in: .main))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundFinish() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testZeroTasksBackgroundQueueBackgroundFinish() {
        let expectation = XCTestExpectation()
        
        sut.finish(queue: .global()) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTaskBackgroundQueueBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTask, in: .global()))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundQueueBackgroundFinish() {
        let queue = DispatchQueue.global()
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.add(fulfillTask(expectationTasks, in: queue))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
     
    func testSeveralTasksMixedQueuesBackgroundFinish() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: .global()))
        sut.add(fulfillTask(expectationTasks, in: .main))
        sut.add(fulfillTask(expectationTasks, in: .global()))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func expectation(withFulfillmentCount count: Int = 3) -> XCTestExpectation {
        let expectation = XCTestExpectation()

        expectation.expectedFulfillmentCount = count
        return expectation
    }
    
    func task(_ queue: DispatchQueue = .main, work: @escaping () -> Void = {}, queueCheckHandler: @escaping (DispatchQueue) -> Void = { _ in }) -> SSGroupExecutor.Task {
        return { handler in
            queue.async {
                work()
                handler()
                queueCheckHandler(DispatchQueue.current)
            }
        }
    }
    
    func fulfillTask(_ expectation: XCTestExpectation, in queue: DispatchQueue, queueCheckHandler: @escaping (DispatchQueue) -> Void = { _ in }) -> SSGroupExecutor.Task {
        let fulfillWork = { expectation.fulfill() }

        DispatchQueue.registerDetection(queue)
        return task(queue, work: fulfillWork ,queueCheckHandler: queueCheckHandler)
    }

    /// Asserts queues are equal.
    ///
    /// Works in background threads. A standard `XCTestsEqual(_:_:)` method works incorrectly.
    ///
    /// - Parameters:
    ///   - queue1: The queue to check equality.
    ///   - queue2: The queue to check equality.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func assertQueuesEqual(_ queue1: DispatchQueue, _ queue2: DispatchQueue, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(queue1 == queue2, "\(queue1) is not equal to \(queue2)", file: file, line: line)
    }

    /// Asserts queues are not equal.
    ///
    /// Works in background threads. A standard `XCTestsNotEqual(_:_:)` method works incorrectly.
    ///
    /// - Parameters:
    ///   - queue1: The queue to check equality.
    ///   - queue2: The queue to check equality.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func assertQueuesNotEqual(_ queue1: DispatchQueue, _ queue2: DispatchQueue, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(queue1 != queue2, "\(queue1) is equal to \(queue2)", file: file, line: line)
    }
}

// MARK: - Dispatch Queue Extension

fileprivate extension DispatchQueue {
    private struct QueueReference {
        weak var queue: DispatchQueue?
    }

    private static let key = DispatchSpecificKey<QueueReference>()

    static func registerDetection(_ queues: DispatchQueue...) {
        queues.forEach { $0.setSpecific(key: key, value: QueueReference(queue: $0)) }
    }

    static var current: DispatchQueue {
        guard let queue = DispatchQueue.getSpecific(key: key)?.queue else { fatalError("Failed to get current queue. Make sure you registered the queue for detection.") }
        return queue
    }
}
