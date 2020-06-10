import Foundation
import XCTest

@testable import SSSugar

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
/// * invalid rev number
/// * adapt batch (many cases)
///
/// # Request Dispathcer
/// * regular
/// * empty
/// * invalid data
/// * revision missmatch
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
    var expectedApplies = 0
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
        
        wait { (exp) in
            dispatch(revisions: revisions) { (error) in
                XCTAssert(error == nil)
                exp.fulfill()
            }
        }
        checkUpdates()
        wait { (exp) in
            checkRevNumber {
                exp.fulfill()
            }
        }
        checkToolsCalled()
    }
    
    func dispatch(revisions: [Revision], handler: @escaping (SSDmRevisionDispatcherError?)->Void) {
        func dispatch() {
            let error = center.dispatchRevisions(revisions)
            handler(error)
        }
        DispatchQueue.bg.async(execute: dispatch)
    }
    
    func checkRevNumber(handler: @escaping ()->Void) {
        func check() {
            XCTAssert(center.revNumber == expectedRevNumber)
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
        XCTAssert(expectedApplies == applier.appliesCount)
    }
    
    func createRevisions() -> [Revision] {
        func createChange(_ idx: Int) -> TestChange {
            let change = TestChange()
            
            change.iCore.identifier = idx
            return change
        }
        let count = 3
        let separator = 2
        let changes = (0..<count).map(createChange)

        return [Revision(number: 1, changes: Array(changes[0..<separator])),
                Revision(number: 2, changes: Array(changes[separator..<count]))]
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
