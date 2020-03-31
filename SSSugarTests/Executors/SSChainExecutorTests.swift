/*

Tests for SSChainExecutor class

 [Done] init
 [Done] add
 [Done] task
    [Done] zero
    [Done] one
    [Done] several
 [Done] background queue
 [Done] mixed queues
 [Done] background finish

*/

import XCTest
@testable import SSSugar

class SSChainExecutorTests: XCTestCase {
    
    let sut = SSChainExecutor()
    
    func testInit() {
        XCTAssertNotNil(SSChainExecutor())
    }
    
    func testAdd() {
        XCTAssertEqual(sut.tasks.count, 0)
        for index in 1...100 {
            sut.add(makeTask())
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
        
        sut.add(makeTaskFullfill(expectationTask))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasks() {
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0]))
        sut.add(makeTaskFullfill(expectationsTasks[1]))
        sut.add(makeTaskFullfill(expectationsTasks[2]))
        sut.finish { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }

    func testZeroTasksBackgroundQueue() {
        let expectation = XCTestExpectation()
        
        sut.finish { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }

    func testOneTaskBackgroundQueue() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()

        sut.add(makeTaskFullfill(expectationTask, in: .global()))
        sut.finish { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }

    func testSeveralTasksBackgroundQueue() {
        let queue = DispatchQueue.global()
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0], in: queue))
        sut.add(makeTaskFullfill(expectationsTasks[1], in: queue))
        sut.add(makeTaskFullfill(expectationsTasks[2], in: queue))
        sut.finish { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksMixedQueue() {
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0], in: .global()))
        sut.add(makeTaskFullfill(expectationsTasks[1], in: .main))
        sut.add(makeTaskFullfill(expectationsTasks[2], in: .global()))
        sut.finish { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testZeroTaskBackgroundFinish() {
        let expectation = XCTestExpectation()
        
        sut.finish(queue: .global()) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }
    
    func testOneTaskBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationTask))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksBackgroundFinish() {
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0]))
        sut.add(makeTaskFullfill(expectationsTasks[1]))
        sut.add(makeTaskFullfill(expectationsTasks[2]))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }

    func testZeroTasksBackgroundQueueBackgroundFinish() {
        let expectation = XCTestExpectation()
        
        sut.add(makeTask(.global()))
        sut.finish(queue: .global()) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
    }

    func testOneTaskBackgroundQueueBackgroundFinish() {
        let expectationTask = XCTestExpectation()
        let expectationFinish = XCTestExpectation()

        sut.add(makeTaskFullfill(expectationTask, in: .global()))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: [expectationTask, expectationFinish], timeout: 1, enforceOrder: true)
    }

    func testSeveralTasksBackgroundQueueBackgroundFinish() {
        let queue = DispatchQueue.global()
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0], in: queue))
        sut.add(makeTaskFullfill(expectationsTasks[1], in: queue))
        sut.add(makeTaskFullfill(expectationsTasks[2], in: queue))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func testSeveralTasksMixedQueueBackgroundFinish() {
        let expectationsTasks = makeExpectationsArray(count: 3)
        let expectationFinish = XCTestExpectation()
        
        sut.add(makeTaskFullfill(expectationsTasks[0], in: .global()))
        sut.add(makeTaskFullfill(expectationsTasks[1], in: .main))
        sut.add(makeTaskFullfill(expectationsTasks[2], in: .global()))
        sut.finish(queue: .global()) { expectationFinish.fulfill() }
        wait(for: expectationsTasks + [expectationFinish], timeout: 1, enforceOrder: true)
    }
    
    func makeExpectationsArray(count: Int) -> [XCTestExpectation] {
        var expectations = [XCTestExpectation]()
        
        for _ in 0..<count {
            expectations.append(XCTestExpectation())
        }
        return expectations
    }
    
    func makeTask(_ queue: DispatchQueue = .main, work: @escaping () -> Void = {}) -> SSChainExecutor.Task {
        return { handler in
            queue.async {
                work()
                handler()
            }
        }
    }
    
    func makeTaskFullfill(_ expectation: XCTestExpectation, in queue: DispatchQueue = .main) -> SSChainExecutor.Task {
        makeTask(queue) { expectation.fulfill() }
    }
}
