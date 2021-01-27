import Foundation
import XCTest

@testable import SSSugar

/// `SSSingleEntityProcessing` protocol extension tests.
///
/// - Note: Test-cases for different notifications, different args and delegate callbacks provided by Updater Tests (see `SSEntityUpdaterTest`).
///
/// # Test plan
///
/// * Test start (obtained)
/// * Test start (not obtained)
/// * Test start (not obtained, not started)
/// * Test stop
class SSSingleEntityProcessingTest: XCTestCase, TPUpdaterDelegate {
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

class TestProcessor<UpdateDelegate: TPUpdaterDelegate> {
    typealias Entity = TestEntity
    
    var entity: TestEntity?
    let executor: SSExecutor
    let obtainer: TestEnityObtainer
    private(set) var updater: TPUpdater<TestProcessor, UpdateDelegate>?
    private(set) var mutator: TPMutator<TestProcessor>?
    let updateCenter: SSUpdateCenter
    weak var updateDelegate: UpdateDelegate?
    
    var startOnEmptyEntity: Bool = true
    
    var onUtilStart: (()->Void)?
    var onUtilStop: (()->Void)?
    
    init(obtainer mObtainer: TestEnityObtainer, executor mExecutor: SSExecutor, updateCenter mUpdateCenter: SSUpdateCenter) {
        obtainer = mObtainer
        executor = mExecutor
        updateCenter = mUpdateCenter
    }
}

extension TestProcessor: TestEntitySource {}

extension TestProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        updater = TPUpdater(receiversManager: updateCenter, source: self, delegate: updateDelegate!)
        mutator = TPMutator(source: self)
        
        updater?.onStart = onUtilStart
        updater?.onStop = onUtilStop
        mutator?.onStart = onUtilStart
        mutator?.onStop = onUtilStop
        
        updater?.delegate = updateDelegate
        updater?.source = self
        mutator?.source = self
    }
}

extension TestProcessor {
    class TPUpdater<TestSource: TestEntitySource, TestDelegate: TPUpdaterDelegate>: SSBaseEntityUpdating {
        typealias Source = TestSource
        typealias Delegate = TestDelegate
        
        var source: TestSource?
        var delegate: TestDelegate?
        var receiversManager: SSUpdateReceiversManaging
        
        var started = false
        var onStart: (()->Void)?
        var onStop: (()->Void)?
        
        init(receiversManager mReceiversManager: SSUpdateReceiversManaging, source mSource: TestSource, delegate mDelegate: TestDelegate) {
            receiversManager = mReceiversManager
            source = mSource
            delegate = mDelegate
        }
        
        func start() {
            started = true
            onStart?()
        }
        
        func stop() {
            started = false
            onStop?()
        }
    }

    class TPMutator<TestSource: SSMutatingEntitySource>: SSBaseEntityMutating {
        var source: TestSource?
        
        var started = false
        
        var onStart: (()->Void)?
        var onStop: (()->Void)?
        
        init(source mSource: TestSource) {
            source = mSource
        }
        
        func start() {
            started = true
            onStart?()
        }
        
        func stop() {
            started = false
            onStop?()
        }
    }
}
