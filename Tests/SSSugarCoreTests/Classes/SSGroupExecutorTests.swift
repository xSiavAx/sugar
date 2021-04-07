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
 [Done] one task background finish
 [Done] several tasks background finish
 [Done] one task background queue background finish
 [Done] several tasks background queue background finish
 [Done] several tasks mixed queues background finish
 */

import XCTest
@testable import SSSugarCore

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
        
        sut.finish {
            expectation.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTask() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()

        sut.add(fulfillTask(expectationTask, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.finish {
            expectationFinish.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasks() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.finish {
            expectationFinish.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testOneTaskBackgroundQueue() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        let testQueue = TestQueue()

        sut.add(fulfillTask(expectationTask, in: testQueue.queue) { XCTAssert(testQueue.isCurrent()) })
        sut.finish {
            expectationFinish.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundQueue() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        let testQueue = TestQueue()

        for _ in 0..<3 {
            sut.add(fulfillTask(expectationTasks, in: testQueue.queue) { XCTAssert(testQueue.isCurrent()) })
        }
        sut.finish {
            expectationFinish.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
     
    func testSeveralTasksMixedQueues() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        let testQueue = TestQueue()

        sut.add(fulfillTask(expectationTasks, in: testQueue.queue) { XCTAssert(testQueue.isCurrent()) })
        sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.add(fulfillTask(expectationTasks, in: testQueue.queue) { XCTAssert(testQueue.isCurrent()) })
        sut.finish {
            expectationFinish.fulfill()

            XCTAssert(Thread.isMainThread)
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testZeroTasksBackgroundFinish() {
        let expectation = XCTestExpectation()
        let testQueue = TestQueue()
        
        sut.finish(queue: testQueue.queue) {
            expectation.fulfill()

            XCTAssert(testQueue.isCurrent())
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTaskBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        let testQueue = TestQueue()
        
        sut.add(fulfillTask(expectationTask, in: .main))
        sut.finish(queue: testQueue.queue) {
            expectationFinish.fulfill()

            XCTAssert(testQueue.isCurrent())
        }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundFinish() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        let testQueue = TestQueue()

        for _ in 0..<3 {
            sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        }
        sut.finish(queue: testQueue.queue) {
            expectationFinish.fulfill()

            XCTAssert(testQueue.isCurrent())
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testOneTaskBackgroundQueueBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        let taskTestQueue = TestQueue(label: "taskTestQueue", value: "taskTestQueue")
        let finishTestQueue = TestQueue(label: "finishTestQueue", value: "finishTestQueue")
        
        sut.add(fulfillTask(expectationTask, in: taskTestQueue.queue) { XCTAssert(taskTestQueue.isCurrent()) })
        sut.finish(queue: finishTestQueue.queue) {
            expectationFinish.fulfill()

            XCTAssert(finishTestQueue.isCurrent())
        }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundQueueBackgroundFinish() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        let taskTestQueue = TestQueue(label: "taskTestQueue", value: "taskTestQueue")
        let finishTestQueue = TestQueue(label: "finishTestQueue", value: "finishTestQueue")

        for _ in 0..<3 {
            sut.add(fulfillTask(expectationTasks, in: taskTestQueue.queue) { XCTAssert(taskTestQueue.isCurrent()) })
        }
        sut.finish(queue: finishTestQueue.queue) {
            expectationFinish.fulfill()

            XCTAssert(finishTestQueue.isCurrent())
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
     
    func testSeveralTasksMixedQueuesBackgroundFinish() {
        let expectationTasks = expectation()
        let expectationFinish = XCTestExpectation()
        let taskTestQueue = TestQueue(label: "taskTestQueue", value: "taskTestQueue")
        let finishTestQueue = TestQueue(label: "finishTestQueue", value: "finishTestQueue")
        
        sut.add(fulfillTask(expectationTasks, in: taskTestQueue.queue) { XCTAssert(taskTestQueue.isCurrent()) })
        sut.add(fulfillTask(expectationTasks, in: .main) { XCTAssert(Thread.isMainThread) })
        sut.add(fulfillTask(expectationTasks, in: taskTestQueue.queue) { XCTAssert(taskTestQueue.isCurrent()) })
        sut.finish(queue: finishTestQueue.queue) {
            expectationFinish.fulfill()

            XCTAssert(finishTestQueue.isCurrent())
        }
        wait(for: [expectationTasks, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func expectation(withFulfillmentCount count: Int = 3) -> XCTestExpectation {
        let expectation = XCTestExpectation()

        expectation.expectedFulfillmentCount = count
        return expectation
    }
    
    func task(_ queue: DispatchQueue = .main, work: @escaping () -> Void = {}, queueCheckHandler: @escaping () -> Void = {}) -> SSGroupExecutor.Task {
        return { handler in
            queue.async {
                work()
                queueCheckHandler()
                handler()
            }
        }
    }
    
    func fulfillTask(_ expectation: XCTestExpectation, in queue: DispatchQueue, queueCheckHandler: @escaping () -> Void = {}) -> SSGroupExecutor.Task {
        return task(queue, work: { expectation.fulfill() }, queueCheckHandler: queueCheckHandler)
    }
}
