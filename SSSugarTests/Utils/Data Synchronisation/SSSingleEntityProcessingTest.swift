import Foundation
import XCTest

@testable import SSSugar

/// # Test plan
///
/// Check queues if possible
///
/// * Test start (obtained)
/// * Test start (not obtained)
/// * Test start (not obtained, not started)
/// * Test stop
class SSSingleEntityProcessingTest: XCTestCase, TestUpdaterDelegate {
    var testQueue: TestQueue!
    var processor: TestProcessor<SSSingleEntityProcessingTest>!
    
    override func setUp() {
        let obtainer = TestEnityObtainer()
        
        testQueue = TestQueue()
        processor = TestProcessor(obtainer: obtainer, executor: testQueue.queue, updateCenter: SSUpdater())
        
        processor.updateDelegate = self
        processor.onUtilStart = checkBgQueue
        processor.onUtilStop = checkBgQueue
        obtainer.onObtain = checkBgQueue
    }
    
    func testStart() {
        wait {(exp) in
            processor.start {
                Self.checkMain()
                exp.fulfill()
            }
        }
        checkStarted()
    }
    
    func testStartNotObtained() {
        processor.obtainer.entity = nil
        wait {(exp) in
            processor.start {
                Self.checkMain()
                exp.fulfill()
            }
        }
        checkStarted()
    }
    
    func testStartNotObtainedNotStarted() {
        processor.obtainer.entity = nil
        processor.startOnEmptyEntity = false
        
        wait {(exp) in
            processor.start {
                Self.checkMain()
                exp.fulfill()
            }
        }
        checkNotStarted()
    }
    
    func testStop() {
        wait {(exp) in
            processor.start {
                Self.checkMain()
                exp.fulfill()
            }
        }
        wait { (exp) in
            processor.stop {
                exp.fulfill()
            }
        }
        checkStopped()
    }
    
    static func checkMain() {
        XCTAssert(Thread.isMainThread);
    }
    
    func checkBgQueue() {
        XCTAssert(testQueue.isCurrent())
    }
    
    func checkStarted() {
        XCTAssert(processor.updater?.started ?? false)
        XCTAssert(processor.mutator?.started ?? false)
    }
    
    func checkNotStarted() {
        XCTAssert(processor.updater == nil)
        XCTAssert(processor.mutator == nil)
    }
    
    func checkStopped() {
        XCTAssert(processor.updater?.started == nil ?? false)
        XCTAssert(processor.mutator?.started == nil ?? false)
    }
}

