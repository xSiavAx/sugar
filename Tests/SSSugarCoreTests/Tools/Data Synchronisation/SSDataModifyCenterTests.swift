import Foundation
import XCTest

@testable import SSSugarCore

/// `SSDataModifyCenter` class tests.
///
/// # Test plan
///
/// For each dispatch (revisions or requests) check notifications created.
/// For revisions dispatch check rev number upgraded.
///
/// # Revision Dispathcer
/// * regular
/// * empty
///
/// # Request Dispathcer
/// * regular
/// * empty
/// * invalid data
///
/// # Mixed
/// * revision missmatch + reaply after revisions
/// * Adapt batch, one canceled
/// * Dispatch requests (delayed, due revision) + Dispatch requests + Reapply
///
class SSDataModifyCenterTests: XCTestCase {
    typealias Change = SSModify
    typealias Request = SSModify
    typealias Center = SSDataModifyCenter<Change, Request, SSDMCenterTestApplier, SSDMCenterTestAdapter>
    typealias Revision = SSDmRevision<Change>
    typealias Batch = SSDmBatch<Request>
    
    var center: Center!
    var adapter: SSDMCenterTestAdapter!
    var applier: SSDMCenterTestApplier!
    var notifier: SSDMCenterTestNotifier!
    
    var expectedRevNumber = 0
    var expectedAdapts = 0
    var expectedAdaptFails = 0
    var expectedApplies = 0
    var expectedApplyFails = 0
    var expectedUpdates: [SSUpdate]!
    
    override func setUp() {
        adapter = SSDMCenterTestAdapter()
        applier = SSDMCenterTestApplier()
        notifier = SSDMCenterTestNotifier()
        
        center = Center(revisionNumber: 0, updateNotifier: notifier, batchApplier: applier, adapter: adapter)
    }
    
    override func tearDown() {
        center = nil
        adapter = nil
        applier = nil
        notifier = nil
    }
    
    func testRevisionDispatch() {
        let revisions = createRevisions()
        
        expectedUpdates = [SSUpdate]()
        expectedRevNumber = 2
        
        revisions.forEach {
            $0.changes.forEach {
                expectedUpdates.append($0.toUpdate())
            }
        }

        wait() { (exp) in
            func onDispatch(_ error: SSDmRevisionDispatcherError?) {
                XCTAssert(error == nil)
                checkUpdates()
            }
            func onApply() {
                XCTAssert(center.revNumber == expectedRevNumber)
                exp.fulfill()
            }
            dispatch(revisions: revisions, onDispatch: onDispatch, onApply: onApply)
        }
        checkToolsCalled()
    }
    
    func testRevisionEmpty() {
        expectedUpdates = [SSUpdate]()
        
        wait { (exp) in
            func onDispatch(_ error: SSDmRevisionDispatcherError?) {
                XCTAssert(error == .emptyRevisions)
                checkUpdates()
                exp.fulfill()
            }
            func onApply() { XCTAssert(false) }
            dispatch(revisions: [], onDispatch: onDispatch, onApply: onApply)
        }
        checkToolsCalled()
    }
    
    func testRequestsDispatch() {
        let requests = createRequests()
        
        expectedUpdates = requests.map { $0.toUpdate() }
        expectedApplies = 1

        wait { (exp) in
            func onDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == nil)
                exp.fulfill()
            }
            center.dispatchReuqests(requests, handler: onDispatch)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func testRequestsEmpty() {
        expectedUpdates = [SSUpdate]()

        wait { (exp) in
            func onDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == .emptyRequests)
                exp.fulfill()
            }
            center.dispatchReuqests([Request](), handler: onDispatch)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func testRequestsInvalidData() {
        let requests = createRequests()
        
        expectedUpdates = [SSUpdate]()
        
        expectedApplyFails = 1
        
        applier.error = .invalidData(indexes: [requests.startIndex, requests.endIndex])

        wait { (exp) in
            func onDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == .invalidData)
                exp.fulfill()
            }
            center.dispatchReuqests(requests, handler: onDispatch)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func testRevMissmatchAndReapply() {
        let requests = createRequests()
        let revisions = createRevisions()
        
        expectedUpdates = [SSUpdate]()
        expectedApplies = 1
        expectedAdapts = revisions.count
        expectedApplyFails = 1
        expectedRevNumber = 2
        
        revisions.forEach {
            $0.changes.forEach {
                expectedUpdates.append($0.toUpdate())
            }
        }
        
        applier.error = .revisionMissmatch

        wait { (exp) in
            func onRequestDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == nil)
                exp.fulfill()
            }
            center.dispatchReuqests(requests, handler: onRequestDispatch)
            
            func onDispatch(_ error: SSDmRevisionDispatcherError?) {
                XCTAssert(error == nil)
                checkUpdates()
                applier.error = nil
                expectedUpdates.append(contentsOf: requests.map { $0.toUpdate() })
            }
            func onApply() {
                XCTAssert(center.revNumber == expectedRevNumber)
            }
            dispatch(revisions: revisions, onDispatch: onDispatch, onApply: onApply)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func testAdaptCancel() {
        let requests = createRequests()
        let revisions = createRevisions()
        
        expectedUpdates = [SSUpdate]()
        expectedApplies = 1
        expectedAdapts = revisions.count
        expectedApplyFails = 1
        expectedRevNumber = 2
        
        revisions.forEach {
            $0.changes.forEach {
                expectedUpdates.append($0.toUpdate())
            }
        }
        requests[1].adaptResult = .canceled
        applier.error = .revisionMissmatch

        wait { (exp) in
            func onRequestDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == nil)
                exp.fulfill()
            }
            center.dispatchReuqests(requests, handler: onRequestDispatch)
            
            func onDispatch(_ error: SSDmRevisionDispatcherError?) {
                XCTAssert(error == nil)
                checkUpdates()
                applier.error = nil
                expectedUpdates.append(contentsOf: requests.compactMap { $0.adaptResult == .canceled ? nil : $0.toUpdate()  })
            }
            func onApply() {
                XCTAssert(center.revNumber == expectedRevNumber)
            }
            dispatch(revisions: revisions, onDispatch: onDispatch, onApply: onApply)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func testMultipleRequestReapply() {
        let requests1 = createRequests()
        let requests2 = createRequests(multiplier: 100)
        let revisions = createRevisions()
        
        expectedUpdates = [SSUpdate]()
        expectedApplies = 1
        expectedAdapts = revisions.count * 2 // 2 batches
        expectedApplyFails = 2
        expectedRevNumber = 2
        
        revisions.forEach {
            $0.changes.forEach {
                expectedUpdates.append($0.toUpdate())
            }
        }
        
        applier.error = .revisionMissmatch

        wait(count: 2) { (exp) in
            func onRequestDispatch(_ error: SSDmRequestDispatchError?) {
                XCTAssert(error == nil)
                exp.fulfill()
            }
            center.dispatchReuqests(requests1, handler: onRequestDispatch)
            center.dispatchReuqests(requests2, handler: onRequestDispatch)
            
            func onDispatch(_ error: SSDmRevisionDispatcherError?) {
                XCTAssert(error == nil)
                checkUpdates()
                applier.error = nil
                expectedUpdates.append(contentsOf: requests1.map { $0.toUpdate() })
                expectedUpdates.append(contentsOf: requests2.map { $0.toUpdate() })
            }
            func onApply() {
                XCTAssert(center.revNumber == expectedRevNumber)
            }
            dispatch(revisions: revisions, onDispatch: onDispatch, onApply: onApply)
        }
        checkUpdates()
        checkToolsCalled()
    }
    
    func dispatch(revisions: [Revision], onDispatch: @escaping (SSDmRevisionDispatcherError?)->Void, onApply: @escaping ()->Void) {
        func dispatch() {
            let error = center.dispatchRevisions(revisions) {
                onApply()
            }
            onDispatch(error)
        }
        DispatchQueue.bg.async(execute: dispatch)
    }
    
    func checkRevNumber(handler: @escaping ()->Void) {
        func check() {
            
            handler()
        }
        DispatchQueue.main.async(execute: check)
    }
    
    func checkUpdates() {
        XCTAssert(notifier.notifies.count == expectedUpdates.count)
        notifier.notifies.forEach { (lhs, idx) in
            let rhs = expectedUpdates[idx]
            
            XCTAssert(lhs.name == rhs.name)
            XCTAssert(lhs.args["identifier"] as? Int != nil)
            XCTAssert(lhs.args["identifier"] as? Int == rhs.args["identifier"] as? Int)
        }
    }
    
    func checkToolsCalled() {
        XCTAssert(expectedAdapts == adapter.adaptsCount)
        XCTAssert(expectedAdaptFails == adapter.failsCount)
        XCTAssert(expectedApplies == applier.appliesCount)
        XCTAssert(expectedApplyFails == applier.failsCount)
    }
    
    func createRevisions() -> [Revision] {
        func createChange(_ idx: Int) -> TestChange {
            let change = TestChange()
            
            change.iCore.identifier = 10 * idx
            return change
        }
        let count = 3
        let separator = 2
        let changes = (0..<count).map(createChange)

        return [Revision(number: 1, changes: Array(changes[0..<separator])),
                Revision(number: 2, changes: Array(changes[separator..<count]))]
    }
    
    func createRequests(multiplier: Int = 1) -> [TestRequest] {
        let count = 3
        
        return (0..<count).map {
            let request = TestRequest()
            
            request.iCore.identifier = multiplier * $0
            return request
        }
    }
}

class SSDMCenterTestAdapter: SSDmBatchAdapting {
    var strategies = Strategies()
    
    typealias Change = SSModify
    typealias Request = SSModify
    
    var error: SSDmBatchAdaptError?
    var adaptsCount = 0
    var failsCount = 0
    
    func adaptBatch(_ batch: Batch, by revisions: [Revision]) -> SSDmBatchAdaptError? {
        if (error == nil) {
            batch.filterRequests { ($0 as! TestRequest).adaptResult != .canceled }
            adaptsCount += 1
        } else {
            failsCount += 1
        }
        return error
    }
}

class SSDMCenterTestApplier: SSDmBatchApplier {
    typealias Request = SSModify
    
    var error: SSDmBatchApplyError?
    var appliesCount = 0
    var failsCount = 0
    
    func applyBatches(_ batches: [Batch], revNumber: Int, handler: @escaping Handler) {
        func apply() {
            if (error == nil) {
                appliesCount += 1
            } else {
                failsCount += 1
            }
            handler(error)
        }
        DispatchQueue.bg.async(execute: apply)
    }
}

class SSDMCenterTestNotifier: SSUpdateNotifier, SSOnMainExecutor {
    var notifies = [SSUpdate]()
    
    func notify(updates: [SSUpdate], onApply: (() -> Void)?) {
        notifies.append(contentsOf: updates)
        if let mOnApply = onApply {
            onMain(mOnApply)
        }
    }
}
