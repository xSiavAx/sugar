import Foundation
import XCTest

@testable import SSSugarCore
@testable import SSSugarExecutors
@testable import SSSugarDataSynchronisation

/// `SSEntityStorageMutator` class tests.
///
/// It's Nothing to tests there, cuz mutator just proxy call to dispatcher.
///
/// # Test plan
///
/// * Mutate
/// * Mutate error
class SSEntityDmMutatorTests: XCTestCase {
    var source: TestSomeEntitySource!
    var dispatcher: TestDmMutatorDispatcher!
    var mutator: TestDmMutator!
    
    override func setUp() {
        source = TestSomeEntitySource()
        dispatcher = TestDmMutatorDispatcher()
        mutator = TestDmMutator(requestDispatcher: dispatcher, source: source)
    }
    
    override func tearDown() {
        source = nil
        dispatcher = nil
        mutator = nil
    }
    
    func testMutate() {
        let requests = [TestRequest(), TestRequest()]
        
        wait { (exp) in
            mutator.mutate(requests: requests) { (error) in
                XCTAssert(Thread.isMainThread)
                XCTAssert(error == nil)
                exp.fulfill()
            }
        }
        XCTAssert(dispatcher.dispatched.count == requests.count)
    }
    
    func testError() {
        let requests = [TestRequest(), TestRequest()]
        
        dispatcher.error = .invalidData
        
        wait { (exp) in
            mutator.mutate(requests: requests) { (error) in
                XCTAssert(Thread.isMainThread)
                XCTAssert(error == .invalidData)
                exp.fulfill()
            }
        }
        XCTAssert(dispatcher.dispatched.count == 0)
    }
}

class TestDmMutator: SSEntityDmMutator<TestSomeEntitySource, TestDmMutatorDispatcher> {
    
}

class TestDmMutatorDispatcher: SSDmRequestDispatcher, SSOnMainExecutor {
    typealias Request = TestRequest
    
    var dispatched = [TestRequest]()
    var error: SSDmRequestDispatchError?
    
    func dispatchReuqests(_ requests: [TestRequest], handler: @escaping Handler) {
        func finish() {
            handler(error)
        }
        func onBG() {
            if (error == nil) {
                dispatched.append(contentsOf: requests)
            }
            onMain(finish)
        }
        DispatchQueue.bg.async(execute: onBG)
    }
}
