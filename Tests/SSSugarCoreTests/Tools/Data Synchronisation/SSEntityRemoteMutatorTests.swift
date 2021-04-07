import Foundation
import XCTest

@testable import SSSugarCore

/// `SSEntityStorageMutator` class tests.
///
/// Mutating job, notification send should be called on BG thread, handler should be called on main.
///
/// # Test plan
///
/// * Start
/// * Stop
/// * Mutate
/// * Mutate with error
/// * Mutate via not started
/// * Mutate via stopped
class SSentityRemoteMutatorTests: XCTestCase, TestUpdateProducer, SSOnMainExecutor {
    var source: TestSomeEntitySource!
    var manager: TestEntityRemoteMutatorReceiverManager!
    var mutator: TestEntityRemoteMutator!
    
    override func setUp() {
        source = TestSomeEntitySource()
        manager = TestEntityRemoteMutatorReceiverManager()
        mutator = TestEntityRemoteMutator(manager: manager, source: source)
    }
    
    override func tearDown() {
        mutator = nil
        manager = nil
        source = nil
    }
    
    func testStart() {
        XCTAssert(manager.receivers.count == 0)
        mutator.start()
        XCTAssert(manager.receivers.first === mutator)
        mutator.stop()
    }
    
    func testStop() {
        mutator.start()
        mutator.stop()
        XCTAssert(manager.receivers.count == 0)
    }
    
    func testMutate() {
        var done = false
        mutator.start()
        wait { (exp) in
            func job(marker: String, handler: @escaping (Error?)->Void) {
                DispatchQueue.bg.async {
                    done = true
                    handler(nil)
                    DispatchQueue.bg.async {[weak self] in
                        self?.notify(marker: marker)
                    }
                }
            }
            func onMutate(error: Error?) {
                XCTAssert(Thread.isMainThread)
                XCTAssert(error == nil)
                exp.fulfill()
            }
            try! mutator.mutate(job: job, handler: onMutate)
        }
        XCTAssert(done)
        mutator.stop()
    }
    
    func testError() {
        mutator.start()
        wait { (exp) in
            func job(marker: String, handler: @escaping (Error?)->Void) {
                DispatchQueue.bg.async {
                    handler(TestMutatorError.mutatorError)
                }
            }
            func onMutate(error: Error?) {
                XCTAssert(Thread.isMainThread)
                XCTAssert(error as! TestMutatorError == TestMutatorError.mutatorError)
                exp.fulfill()
            }
            try! mutator.mutate(job: job, handler: onMutate)
        }
        mutator.stop()
    }
    
    func testNotStarted() {
        func noJob(marker: String, handler: @escaping (Error?)->Void) {}
        func noHandle(error: Error?) {}
        
        do {
            try mutator.mutate(job: noJob, handler: noHandle)
            XCTAssert(false)
        } catch {
            XCTAssert(error as! SSEntityRemoteMutatorError == SSEntityRemoteMutatorError.notStarted)
        }
    }
    
    func testStopped() {
        func noJob(marker: String, handler: @escaping (Error?)->Void) {}
        func noHandle(error: Error?) {}
        
        mutator.start()
        mutator.stop()
        
        do {
            try mutator.mutate(job: noJob, handler: noHandle)
            XCTAssert(false)
        } catch {
            XCTAssert(error as! SSEntityRemoteMutatorError == SSEntityRemoteMutatorError.notStarted)
        }
    }
    
    private func notify(marker: String) {
        func apply() {
            mutator.apply()
        }
        mutator.reactions()[Self.updateTitle]!(produceUpdate(marker: marker))
        onMain(apply)
    }
}

class TestEntityRemoteMutator: SSEntityRemoteMutator<TestSomeEntitySource> {
    override func reactions() -> SSUpdate.ReactionMap {
        return testReactions()
    }
}

extension TestEntityRemoteMutator: TestUpdateReceiver {
    func onUpdate(marker: String) {
        handleUpdate(with: marker)
    }
}

class TestEntityRemoteMutatorReceiverManager: SSUpdateReceiversManaging {
    var receivers = [SSUpdateReceiver]()
    
    func addReceiver(_ receiver: SSUpdateReceiver) {
        receivers.append(receiver)
    }
    
    func removeReceiver(_ receiver: SSUpdateReceiver) {
        guard let index = index(of: receiver) else { fatalError("Receiver not found") }
        
        receivers.remove(at: index)
    }
    
    func index(of receiver: SSUpdateReceiver) -> Int? {
        return receivers.lastIndex { receiver === $0 }
    }
}
