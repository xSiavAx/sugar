import Foundation
import XCTest

@testable import SSSugar

/// `SSEntityStorageMutator` class tests.
///
/// Mutating job, notification send should be called on BG thread, handler should be called on main.
///
/// # Test plan
///
/// * Mutate
/// * Mutate with exception
class SSEntityStorageMutatorTests: XCTestCase {
    var mutator: TestStorageMutator!
    var source: TestSomeEntitySource!
    var executor: TestMutatorExecutor!
    var notifier: TestMutatorNotifier!
    
    override func setUp() {
        source = TestSomeEntitySource()
        executor = TestMutatorExecutor()
        notifier = TestMutatorNotifier()
        mutator = TestStorageMutator(executor: executor, notifier: notifier, source: source)
    }
    
    override func tearDown() {
        source = nil
        executor = nil
        notifier = nil
        mutator = nil
    }
    
    func testMutate() {
        wait { (exp) in
            mutator.action { (error) in
                XCTAssert(Thread.isMainThread)
                XCTAssert(error == nil)
                exp.fulfill()
            }
        }
        XCTAssert(executor.called)
        XCTAssert(notifier.postedUpdates.count == 1)
    }
    
    func testError() {
        wait { (exp) in
            mutator.actionWithException { (error) in
                XCTAssert(Thread.isMainThread)
                XCTAssert(error as! TestMutatorError == TestMutatorError.mutatorError)
                exp.fulfill()
            }
        }
        XCTAssert(executor.called)
        XCTAssert(notifier.postedUpdates.count == 0)
    }
}

class TestStorageMutator: SSEntityDBMutator<TestSomeEntitySource>, TestUpdateProducer {
    func action(_ handler: @escaping (Error?)->Void) {
        func job(marker: String) -> SSUpdate {
            return produceUpdate(marker: marker)
        }
        mutate(job: job(marker:), handler: handler)
    }
    
    func actionWithException(_ handler: @escaping (Error?)->Void) {
        func job(marker: String) throws -> SSUpdate {
            throw TestMutatorError.mutatorError
        }
        mutate(job: job(marker:), handler: handler)
    }
}

class TestMutatorExecutor: SSExecutor {
    var called = false
    
    func execute(_ work: @escaping () -> Void) {
        func onBG() {
            guard !called else { fatalError("Unexpected call") }
            called = true
            work()
        }
        DispatchQueue.bg.async(execute: onBG)
    }
    
    func reset() {
        called = false
    }
}

class TestMutatorNotifier: SSUpdateNotifier {
    var postedUpdates = [SSUpdate]()
    
    func notify(updates: [SSUpdate], onApply: (() -> Void)?) {
        postedUpdates.append(contentsOf: updates)
        DispatchQueue.main.async {
            onApply?()
        }
    }
}
